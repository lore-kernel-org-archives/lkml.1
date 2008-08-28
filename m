Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYH1ObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYH1ObS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYH1ObG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:31:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbYH1ObF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:31:05 -0400
Date: Thu, 28 Aug 2008 16:30:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828143042.GA12644@elte.hu>
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu> <20080828141513.GC31444@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828141513.GC31444@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> For this, if this time limit does kick in, we should at the very least 
> print something out to let the user know this happened. After all, 
> this is more of a safety net anyway, and if we are hitting the limit, 
> the user should be notified. Perhaps even tell the user that if this 
> behaviour is expected, to up the sysctl <var> by more.

yeah, agreed, this is a reasonable suggestion. Peter, do you agree?

	Ingo
