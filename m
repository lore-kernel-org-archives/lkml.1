Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYJDIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYJDIxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYJDIxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:53:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbYJDIxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:53:11 -0400
Date: Sat, 4 Oct 2008 10:52:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0/9] traps: x86: finalize unification of traps.c
Message-ID: <20081004085251.GA8080@elte.hu>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Hi Ingo,
> 
> This series unifies traps_32.c and traps_64.c.

wow, very nice! I've applied them to tip/x86/traps:

f58f3d5: traps: x86: finalize unification of traps.c
bf395d6: traps: x86: make traps_32.c and traps_64.c equal
f156f35: traps: x86: various noop-changes preparing for unification of traps_xx.c
70cfe30: traps: x86_64: use task_pid_nr(tsk) instead of tsk->pid in do_general_protection
dc89ce0: traps: i386: expand clear_mem_error and remove from mach_traps.h
6f8063f: traps: x86_64: make io_check_error equal to the one on i386
d025445: traps: i386: use preempt_conditional_sti/cli in do_int3
2180afa: traps: x86_64: make math_state_restore more like i386
686cc4a: traps: x86: converge trap_init functions

thanks Alexander!

	Ingo
