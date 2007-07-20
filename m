Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXGTFYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXGTFYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXGTFYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:24:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:54451 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXGTFYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:24:03 -0400
Message-ID: <46A046F1.7040207@qumranet.com>
Date: Fri, 20 Jul 2007 08:24:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under arch-level
 Virtualization option
References: <1184905342.10380.263.camel@localhost.localdomain>
In-Reply-To: <1184905342.10380.263.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 20 Jul 2007 08:24:01 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Any objections?
>
> Rusty.
> ===
> Having KVM appear in the middle of "drivers" is kinda strange, and
> having it alone under a menu called "virtualization" doubly so.
>
> 1) Move the "Virtualization" menu into the arch-specific i386 and
>    x86-64 Kconfig.
>   

Virtualization is hardly x86 specific.  How about moving it to
top-level, and having individual items disable themselves on archs they
don't apply to?

Otherwise we end up with $NARCH copies of that Kconfig, each slightly
different.  The top-level entry can be made to depend on the archs that
actually have some virt capability, so as not to show empty an menu.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

