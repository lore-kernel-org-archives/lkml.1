Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbYKZCNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbYKZCNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYKZCM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:12:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbYKZCM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:12:59 -0500
Date: Wed, 26 Nov 2008 03:12:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human
	readable output
Message-ID: <20081126021243.GA17567@elte.hu>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126003936.GA26937@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


there's a small inconsistency here:

# cat available_tracers 
function-graph function sched_switch nop

note the '-' versus '_' separators. I wouldnt mind renaming the sched 
tracer to sched-switch. (and some of the other tracers as well)

	Ingo
