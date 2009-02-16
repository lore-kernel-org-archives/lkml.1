Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZBPHww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZBPHww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZBPHwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:52:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZBPHwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:52:43 -0500
Date: Mon, 16 Feb 2009 08:52:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask bugfixes (re-xmit)
Message-ID: <20090216075233.GA30639@elte.hu>
References: <200902161739.58576.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902161739.58576.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (Just the vital ones: the other two are speculative problems we can argue about
>  separately).
> 
> The following changes since commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a:
>   Linus Torvalds (1):
>         Linux 2.6.29-rc5
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master
> 
> Rusty Russell (2):
>       cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
>       cpumask: Use cpu_*_mask accessors code: alpha
> 
>  arch/alpha/kernel/process.c               |    8 ++++----
>  arch/alpha/kernel/smp.c                   |   12 ++++++------
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 +++++++-----
>  3 files changed, 17 insertions(+), 15 deletions(-)

Thanks, these look a lot more surgical for late -rc's than the
previous one.

	Ingo
