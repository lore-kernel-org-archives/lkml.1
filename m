Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYBZHP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYBZHP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYBZHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:15:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYBZHPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:15:20 -0500
Date: Tue, 26 Feb 2008 08:14:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for
	intel cpu
Message-ID: <20080226071459.GA24820@elte.hu>
References: <200802252320.01534.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802252320.01534.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> early_init_intel is introduced by
> 
> commit 2b16a2353814a513cdb5c5c739b76a19d7ea39ce
> Author: Andi Kleen <ak@suse.de>
> Date:   Wed Jan 30 13:32:40 2008 +0100
> 
>     x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection
> 
> set CONSTANT_TSC for intel cpus
> 
> but it already set in init_intel
> 
> don't need to set that two times in early_init_intel() and init_intel. this patch remove one.
> 
> also fix error in early_init_intel and reference about x86_capality, because it
> is array already.., prevent possible data corruption...
> 
> this should be applied for 2.6.25

thanks Yinghai, applied.

	Ingo
