Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYG1PHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYG1PHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYG1PG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:06:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37986 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbYG1PG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:06:58 -0400
Date: Mon, 28 Jul 2008 17:06:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86 tracehook
Message-ID: <20080728150634.GC32111@elte.hu>
References: <20080727063737.09934154280@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727063737.09934154280@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Hi!  The generic tracehook patches were merged, so now the arch stuff 
> can go in any time.  These are the pending x86 changes.  The only 
> difference from what I posted before are fixing up some tiny syntax 
> nits in syscall.h that made gcc-3.x unhappy.
> 
> Sorry Ingo, I had already done this with git-rebase before I read your 
> admonition about that today.  (Anyway, the prerequisite tracehook 
> series went in via patches rather than a GIT merge, so I don't think 
> the x86/tracehook branch forked from my own tracehook branch could 
> still have been used.)

that's OK. It only gets painful once someone starts relying on a branch.

> The following changes since commit 8be1a6d6c77ab4532e4476fdb8177030ef48b52c:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git x86-tracehook
> 
> Roland McGrath (6):
>       x86: tracehook_signal_handler
>       x86: tracehook syscall
>       x86: tracehook: asm/syscall.h
>       x86 signals: use asm/syscall.h
>       x86: tracehook: TIF_NOTIFY_RESUME
>       x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

pulled into tip/x86/tracehook - thanks Roland!

	Ingo
