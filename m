Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYIOHR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYIOHR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 03:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYIOHRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 03:17:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYIOHRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 03:17:48 -0400
Date: Mon, 15 Sep 2008 09:17:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] FTRACE_STARTUP_TEST should depend on FTRACE.
Message-ID: <20080915071732.GA24442@elte.hu>
References: <1221436952-15206-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221436952-15206-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0051]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> Doesn't make sense to do an FTRACE startup test when FTRACE isn't even 
> being compiled in.

hm, not sure - there is a bit of a dual personality here: 'ftrace' also 
means the 'function tracer', which is one of the tracers implemented in 
kernel/trace/*. The correct dependency is on CONFIG_TRACING - and 
CONFIG_FTRACE_STARTUP_TEST already depends on that.

	Ingo
