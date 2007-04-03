Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXDCVp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXDCVp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXDCVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:45:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXDCVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:45:58 -0400
Message-ID: <4612CAF4.908@zytor.com>
Date: Tue, 03 Apr 2007 14:45:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Arnd Bergmann <arnd@arndb.de>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andi Kleen <ak@suse.de>, Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704031951.00544.arnd@arndb.de> <4612A5F0.2080609@goop.org> <200704032142.51976.arnd@arndb.de> <4612B123.2040105@goop.org> <4612B303.5000109@zytor.com> <4612C077.60502@goop.org>
In-Reply-To: <4612C077.60502@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> So, what you're saying is:
> 
>    1. assuming there's going to be a vast number of miscellaneous devices
>    2. it would be best if there were one per device rather than one per
>       hypervisor per device
>    3. so we'd have one linux device driver
> 
> But this implies that the work is just pushed off into all the
> hypervisors to support this new device over the generic interface;
> there's no overall reduction of code or complexity, other than making
> "wc" on the kernel source smaller.
> 

Sure there is, assuming you deal about heterogenous clients.  I'm not 
sure Xen is (although that is, as far as I understand, being remedied), 
which might explain your different perspective.

Consider that this may not even be about Linux -- having these standard 
devices would enable, say, 'doze device drivers to be written and shared.

> That said, something like USB is probably the best bet for this kind of
> low-performance device.  I think.  Not that I really know anything about
> USB.

USB is evil in the extreme for this kind of stuff.  Although in theory 
you can have any HCI you want, in practice the ones that are implemented 
requires a very complex framework for full compatiblity.

	-hpa
