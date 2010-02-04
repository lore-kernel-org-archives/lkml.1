Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0BDIY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:24:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab0BDIYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:24:53 -0500
Date: Thu, 4 Feb 2010 09:24:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, x86 <x86@kernel.org>
Subject: Re: mtrr/state.c unused?
Message-ID: <20100204082428.GA21938@elte.hu>
References: <20100203202425.GC1367@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203202425.GC1367@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> It looks like <arch/x86/kernel/cpu/mtrr/state.c> is not used by
> anything in the kernel.

Good catch - i dont see it used either. Mind sending a patch?

> 
> Besides cleanups, the only relevant patch in the git history is:
> 
> commit 2ec1df4130c60d1eb49dc0fa0ed15858fede6b05
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Oct 11 11:16:28 2007 +0200
> 
>     i386: move kernel/cpu/mtrr
> 
> 
> which adds it. Hmm...

Might be a dead code artifact from the original unification.

Thanks,

	Ingo
