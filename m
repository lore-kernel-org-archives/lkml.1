Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYL3FkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYL3FkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 00:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYL3FkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 00:40:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYL3FkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 00:40:01 -0500
Date: Tue, 30 Dec 2008 06:39:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] futex_key reference accounting fixes
Message-ID: <20081230053938.GA11037@elte.hu>
References: <20081229185238.10342.75651.stgit@Aeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229185238.10342.75651.stgit@Aeon>
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


* Darren Hart <dvhltc@us.ibm.com> wrote:

> This series fixes several problems with symmetric reference counting of the
> futex keys.
> 
> ---
> 
> Darren Hart (2):
>       futex: correct futex_requeue futex key ref counting in requeue loop
>       futex: make futex_(get|put)_key() calls symmetric
> 
> 
>  kernel/futex.c |   68 ++++++++++++++++++++++++++++++--------------------------
>  1 files changed, 36 insertions(+), 32 deletions(-)

applied to tip/core/futexes, thanks Darren!

	Ingo
