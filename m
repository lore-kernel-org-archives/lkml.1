Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZHPPzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZHPPzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZHPPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:55:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbZHPPzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:55:22 -0400
Date: Sun, 16 Aug 2009 17:55:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Kelly <mark@bifferos.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
Message-ID: <20090816155507.GA2791@elte.hu>
References: <58001.1250437590@bifferos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58001.1250437590@bifferos.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Kelly <mark@bifferos.com> wrote:

 > From about 2.6.29, CPU detection appears to have changed such 
 > that
> a patch is required for RDC x86-compatible CPUs (possibly other 
> undetected x86 CPUs as well).  A work-around was to add a couple 
> of null checks to arch/x86/kernel/cpu/common.c, e.g.:
> 
> if (this_cpu && this_cpu->c_identify)
>              ~~~~~~~~~~~~~~~~~~~~~~~
>     this_cpu->c_identify(c);
> 
> However the patch below attempts to do this detection properly, 
> and also detect all variants of RDC CPUs. I have also added some 
> documentation for this platform.
> 
> See also:
> http://sites.google.com/site/bifferboard/Home/s3282-kernel-issues

ok, this definitely looks like a step in the right direction. The 
patch needs a few small fixes:

 - the one you sent was line-wrapped. (please see
   Documentation/email-clients.txt about how to send plain-text 
   patches.)

 - there's a few stylistic errors in the patch, 
   scripts/checkpatch.pl reports:

     total: 24 errors, 5 warnings, 0 checks, 157 lines checked

	Ingo
