Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbYIFMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbYIFMEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYIFMEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:04:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYIFMEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:04:09 -0400
Date: Sat, 6 Sep 2008 14:03:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
Message-ID: <20080906120346.GA30964@elte.hu>
References: <20080906050602.409299112@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906050602.409299112@goodmis.org>
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

> I spent the day chasing a bug that would hang PPC on boot up when 
> ftrace is configured in. I found that it was simply a stupid bug I did 
> to handle the non MCOUNT_RECORD case. Since I was testing only on x86, 
> and the MCOUNT_RECORD is automatically set for dynamic ftrace if it is 
> available, I did not test the case where MCOUNT_RECORD was not set.
> 
> I have not finished porting MCOUNT_RECORD to PPC, but have found that 
> it has caused some issues for archs that do not support it yet.
> 
> This patch series handles these cases.

applied to tip/tracing/ftrace, thanks Steve.

	Ingo
