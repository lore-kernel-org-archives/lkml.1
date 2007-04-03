Return-Path: <linux-kernel-owner+w=401wt.eu-S1422672AbXDCUDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672AbXDCUDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422671AbXDCUDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:03:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422672AbXDCUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:03:53 -0400
Message-ID: <4612B303.5000109@zytor.com>
Date: Tue, 03 Apr 2007 13:03:15 -0700
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
References: <4611652F.700@zytor.com> <200704031951.00544.arnd@arndb.de> <4612A5F0.2080609@goop.org> <200704032142.51976.arnd@arndb.de> <4612B123.2040105@goop.org>
In-Reply-To: <4612B123.2040105@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yes, and that's the core of the Xen netfront.  But is there really much
> code which can be shared between different hypervisors?  When you get
> down to it, all the real code is hypervisor-specific stuff for setting
> up ringbuffers and dealing with interrupts.  Like all the other network
> drivers.
> 

One thing, Jeremy, which I think is being a bit misleading here: you're 
focusing on big, performance-critical stuff.  Those things are going to 
be the ones which has the most win to implement in hypervisor-specific 
ways.  Although we can offer models for some hypervisors (and G-d knows 
there are enough implementations out there of virtual disk which are 
almost identical), they're clearly not going to be universal.

However, there are other things; console is some, or my original 
example, which was random number generation.  For those, the benefit of 
unification is proportionally greater, simply because the win of 
anything hypervisor-specific is much smaller.

	-hpa
