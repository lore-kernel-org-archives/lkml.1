Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZCVRDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZCVRDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZCVRDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:03:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZCVRDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:03:39 -0400
Date: Sun, 22 Mar 2009 18:03:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: don't profile branches
	on graph tracer
Message-ID: <20090322170333.GA6936@elte.hu>
References: <1237741289-14926-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237741289-14926-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: fix slow tracing
> 
> The core kernel tracing is protected against soft branch 
> profiling, but not the x86 ftrace arch part. Let's fix it.

right now we should simply disable the branch profiler if any 
function tracing variant is enabled.

We should probably mark it CONFIG_BROKEN until it's properly 
per-cpu-ized.

	Ingo
