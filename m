Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbYDZLN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbYDZLN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYDZLNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:13:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35320 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYDZLNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:13:21 -0400
Date: Sat, 26 Apr 2008 13:13:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH v2] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080426111307.GA401@elte.hu>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080424223947.55c053f6@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424223947.55c053f6@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> From 8979ee55cb6a429c4edd72ebec2244b849f6a79a Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Sat, 12 Apr 2008 00:18:57 +0300
> Subject: [PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
> 
> Mmiotrace is not reliable with multiple CPUs and may miss events. Drop 
> to single CPU when mmiotrace is activated.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
> 
> I've tested this patch on my Core 2 Duo laptop, and with "[PATCH v2] 
> Check for breakpoint in text_poke to eliminate bug_on" cpu hotplug 
> seems to work fine on a sched-devel/latest SMP kernel both with and 
> without CONFIG_HOTPLUG_CPU.

thanks Pekka, applied.

	Ingo
