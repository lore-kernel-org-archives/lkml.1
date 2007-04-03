Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbXDCVA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbXDCVA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXDCVA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:00:56 -0400
Received: from gw.goop.org ([64.81.55.164]:55337 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbXDCVAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:00:55 -0400
Message-ID: <4612C077.60502@goop.org>
Date: Tue, 03 Apr 2007 14:00:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arnd Bergmann <arnd@arndb.de>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andi Kleen <ak@suse.de>, Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704031951.00544.arnd@arndb.de> <4612A5F0.2080609@goop.org> <200704032142.51976.arnd@arndb.de> <4612B123.2040105@goop.org> <4612B303.5000109@zytor.com>
In-Reply-To: <4612B303.5000109@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> However, there are other things; console is some, or my original
> example, which was random number generation.  For those, the benefit
> of unification is proportionally greater, simply because the win of
> anything hypervisor-specific is much smaller. 

So, what you're saying is:

   1. assuming there's going to be a vast number of miscellaneous devices
   2. it would be best if there were one per device rather than one per
      hypervisor per device
   3. so we'd have one linux device driver

But this implies that the work is just pushed off into all the
hypervisors to support this new device over the generic interface;
there's no overall reduction of code or complexity, other than making
"wc" on the kernel source smaller.

That said, something like USB is probably the best bet for this kind of
low-performance device.  I think.  Not that I really know anything about
USB.

    J
