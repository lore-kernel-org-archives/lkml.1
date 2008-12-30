Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYL3Heh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYL3Heh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYL3He3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:34:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYL3He2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:34:28 -0500
Date: Tue, 30 Dec 2008 08:34:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230073414.GA29896@elte.hu>
References: <4959443f.09a1660a.44f3.2686@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4959443f.09a1660a.44f3.2686@mx.google.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: new tracer
> 
> This patch adapts kmemtrace raw events tracing to the unified tracing 
> API. It applies on latest tip/tracing/kmemtrace To enable and use this 
> tracer, just do the following:
> 
> echo kmemtrace > /debugfs/tracing/current_tracer
> cat /debugfs/tracing/trace

nice! I've put this into a separate topic for the time being: 
tip/tracing/kmemtrace2, so that Pekka and Eduard can comment on it.

	Ingo
