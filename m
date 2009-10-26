Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZJZUGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZJZUGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZJZUGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:06:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbZJZUGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:06:13 -0400
Date: Mon, 26 Oct 2009 21:05:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Bug #14389] Build system issue
Message-ID: <20091026200555.GB24682@elte.hu>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.OJG.Zre5KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dRYo8ss7vL.A.OJG.Zre5KB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14389
> Subject		: Build system issue
> Submitter	: Peter Zijlstra <peterz@infradead.org>
> Date		: 2009-10-09 8:58 (18 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=575543347b5baed0ca927cb90ba8807396fe9cc9
> References	: http://marc.info/?l=linux-kernel&m=125507914909152&w=4
> 

This should be fixed upstream by:

 2331d1a: kbuild: revert "save ARCH & CROSS_COMPILE ..."

Thanks,

	Ingo

