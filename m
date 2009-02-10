Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZBJOQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZBJOQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZBJOQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:16:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZBJOQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:16:29 -0500
Date: Tue, 10 Feb 2009 15:16:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090210141612.GB16147@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu> <20090209140610.GA21560@elte.hu> <20090209203005.GA10473@elte.hu> <4991878C.9040802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4991878C.9040802@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Tejun Heo <tj@kernel.org> wrote:

> Ingo Molnar wrote:
> >> Note that i spread the patches the following way: #001-003 are in tip:x86/urgent, 
> > 
> > FYI, -tip testing found this new build failure with MATH_EMU:
> > 
> > arch/x86/kernel/traps.c:904: error: conflicting types for 'math_emulate'
> > /home/mingo/tip/arch/x86/include/asm/traps.h:80: error: previous declaration of 'math_emulate' was here
> 
> This is the missing asmlinkage one, right?

yeah - fixed this already by amending that commit. No new problems with
these particular commits.

	Ingo
