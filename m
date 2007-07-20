Return-Path: <linux-kernel-owner+w=401wt.eu-S934827AbXGTHfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934827AbXGTHfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXGTHfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:35:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:54511 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934400AbXGTHfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:35:30 -0400
Message-ID: <46A065C0.6030700@argo.co.il>
Date: Fri, 20 Jul 2007 10:35:28 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Where did KVM go in 2.6.22-git9?
References: <46A02BFB.3090500@tmr.com>
In-Reply-To: <46A02BFB.3090500@tmr.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 20 Jul 2007 10:35:28 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I just built a 2.6.22-git9 kernel, and when I run oldconfig it (a)
> sets the processor type to pentium-pro, and (b) the KVM stuff simply
> isn't in the config. Before I spend a lot of time on this, was it
> disabled temporarily for some reason, or is it a known bug, or ???
>
> Processor is a Core2 E6600, and the starting config has KVM.
>
> Strong suggestion: put KVM in processor type and options, and if the
> CPU type selected supports the feature, let the builder turn it on in
> one place and have Kconfig turn on whatever voodoo is needed to allow
> it, rather than have people trying to find out what depends have
> changed with each release. I see KVm depends on X86_CMPXCHG64 which
> simply doesn't seem to be defined directly anywhere.
>
> Going back to 2.6.21.6 until whatever changed is at least documented.
>

Kconfig changes got kvm temporarily disabled on i386 nonpae.  Current
-git has it back.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

