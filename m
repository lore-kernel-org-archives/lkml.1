Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZCDTU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZCDTU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZCDTUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:20:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZCDTUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:20:48 -0500
Message-ID: <49AED391.1030500@zytor.com>
Date: Wed, 04 Mar 2009 11:16:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org>	<200902282309.07576.nickpiggin@yahoo.com.au> <49AB19E1.4050604@goop.org> <49AED092.5080902@codemonkey.ws>
In-Reply-To: <49AED092.5080902@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> 
> I think this is a bit misleading.  I think you can understand the true 
> differences between Xen and KVM by s/hypervisor/Operating System/. 
> Fundamentally, a hypervisor is just an operating system that provides a 
> hardware-like interface to it's processes.
> 
[...]

> 
> The real difference between KVM and Xen is that Xen is a separate 
> Operating System dedicated to virtualization.  In many ways, it's a fork 
> of Linux since it uses quite a lot of Linux code.
> 
> The argument for Xen as a separate OS is no different than the argument 
> for a dedicated Real Time Operating System, a dedicated OS for embedded 
> systems, or a dedicated OS for a very large system.
> 

In particular, Xen is a microkernel-type operating system.  The dom0 
model is a classic single-server, in the style of Mach.  A lot of the 
"Xen could use a distributed dom0" arguments were also done with Mach 
("the real goal is a multi-server") but such a system never materialized 
(Hurd was supposed to be one.)  Building multiservers is *hard*, and 
building multiservers which don't suck is even harder.

	-hpa
