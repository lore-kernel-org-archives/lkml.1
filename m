Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYACKuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYACKuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYACKuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:50:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbYACKuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:50:09 -0500
Date: Thu, 3 Jan 2008 11:49:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [12/20] x86: Use a per cpu timer for correctable
	machine check checking
Message-ID: <20080103104956.GE29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005007.CE13A14D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005007.CE13A14D40@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Previously the code used a single timer that then used 
> smp_call_function to interrupt all CPUs while the original CPU was 
> waiting for them.
> 
> But it is better / more real time and more power friendly to simply 
> run individual timers on each CPU so they all do this independently.
> 
> This way no single CPU has to wait for all others.

i think we should unify this code first and provide it on 32-bit as 
well.

	Ingo
