Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbXKIPWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbXKIPWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760658AbXKIPWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:22:04 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42751 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758360AbXKIPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:22:03 -0500
Date: Fri, 9 Nov 2007 16:21:39 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86 kprobes_64.c: make 3 functions static
Message-ID: <20071109152139.GF26163@stusta.de>
References: <20071109060326.GV26163@stusta.de> <20071109070609.3ff46629@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071109070609.3ff46629@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 07:06:09AM -0800, Arjan van de Ven wrote:
> On Fri, 9 Nov 2007 07:03:26 +0100
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch makes the following needlessly global functions static:
> > - kprobe_handler()
> > - trampoline_probe_handler()
> > - post_kprobe_handler()
> > 
> 
> 
> while I appreciate your cleanups, I would like to ask you to be a bit
> careful with the x86/ ones; some of these are for now deliberate to
> make unification between the 32 and 64 ones possible.. eg we're working
> on getting the more cosmetic (and in this context, removing a static is
> more or less cosmetic) changes away so that "diff" shows us the *real*
> differences between the 32 and 64 bit versions... adding back in the
> static is the opposite direction ;)
> 
> So.. if you find ones that are real for both 32 and 64 bit, by all
> means, but otherwise be a bit careful..

I tried to ensure that my cleanup patches do not make the 32 and 64 bit 
versions more different.

And e.g. in this case the kprobe_handler() and post_kprobe_handler() 
statifications remove the cosmetic difference of the 64bit ones not 
being static.  ;-)

Anyway, if any or all of my patches conflict with any other work simply 
ignore them and I'll resend them after 2.6.25-rc1 (if they still both 
apply and make sense).

> Greetings,
>    Arjan van de Ven

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

