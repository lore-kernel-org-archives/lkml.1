Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZDRHN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZDRHN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZDRHNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:13:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZDRHNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:13:20 -0400
Date: Sat, 18 Apr 2009 09:13:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] tracing/events: enable code with EVENT_TRACING not
	EVENT_TRACER
Message-ID: <20090418071307.GC7678@elte.hu>
References: <20090417211135.408179566@goodmis.org> <20090417211230.723241189@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417211230.723241189@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> -#ifdef CONFIG_EVENT_TRACER
> +#ifdef CONFIG_EVENT_TRACING

Hm, my crystal ball predicts many such incidents in future years to 
come.

This:

  s/CONFIG_EVENT_TRACER/CONFIG_EVENT_TRACER_PLUGIN

might help. Or not.

	Ingo
