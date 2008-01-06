Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYAFK0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYAFK0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 05:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYAFK0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 05:26:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49017 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYAFK0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 05:26:00 -0500
Date: Sun, 6 Jan 2008 11:25:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] profile: further Codying Style fixes
Message-ID: <20080106102544.GB11765@elte.hu>
References: <20080104152858.1fb9b868@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104152858.1fb9b868@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Further codying style fixes on top of:
> http://marc.info/?l=linux-kernel&m=119940325306693&w=2

thanks, applied.

> 1 Warning is still not killed:
> WARNING: externs should be avoided in .c files
> #509: FILE: profile.c:509:
> +       extern int setup_profiling_timer(unsigned int multiplier);
> 
> I don't know how to fix it :-/

simply move that line to include/linux/profile.h. (no need to preserve 
the CONFIG_SMP - on !SMP the function prototype line will not be used)

	Ingo
