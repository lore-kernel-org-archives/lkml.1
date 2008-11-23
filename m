Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYKWHkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYKWHkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 02:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYKWHkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 02:40:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYKWHkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 02:40:03 -0500
Date: Sun, 23 Nov 2008 08:39:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #11965] regression introduced by - timers: fix
	itimer/many thread hang
Message-ID: <20081123073929.GA23229@elte.hu>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.t7C.D8HKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vyitTh0pP2N.A.t7C.D8HKJB@chimera>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report 
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions 
> from 2.6.27.  Please verify if it still should be listed and let me 
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11965
> Subject		: regression introduced by - timers: fix itimer/many thread hang
> Submitter	: Doug Chapman <doug.chapman@hp.com>
> Date		: 2008-11-06 11:03 (17 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f06febc96ba8e0af80bcc3eaec0a109e88275fac
> References	: http://marc.info/?l=linux-kernel&m=122596943416648&w=4
> Handled-By	: Frank Mayhar <fmayhar@google.com>
> 		  Peter Zijlstra <peterz@infradead.org>
> 		  Ingo Molnar <mingo@elte.hu>

the hang is fixed by:

  commit ad474caca3e2a0550b7ce0706527ad5ab389a4d4
  Author: Oleg Nesterov <oleg@redhat.com>
  Date:   Mon Nov 10 15:39:30 2008 +0100

    fix for account_group_exec_runtime(), make sure ->signal can't be freed under rq->lock

	Ingo
