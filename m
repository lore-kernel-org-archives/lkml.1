Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYISLFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYISLFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYISLFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:05:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYISLFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:05:00 -0400
Date: Fri, 19 Sep 2008 13:04:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Message-ID: <20080919110449.GB30624@elte.hu>
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net> <c62985530809190348h3a74de3aqd0ca2e893b11bb8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809190348h3a74de3aqd0ca2e893b11bb8c@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> It seems we have two "none" tracers now. Why not seeing this nop 
> tracer as an improvment of the current "none tracer" ?
> 
> As a result the none tracer contained in trace.c could be replaced by 
> this new one as the default tracer. And that's said, that will enable 
> trace_printk by default even when no tracer is selected by the user.
> 
> What do you think about it?

hmm ... good idea. There are some special properties of the none tracer 
(it inhibits trace output for example), and those should be discontinued 
i guess.

	Ingo
