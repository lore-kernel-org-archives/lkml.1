Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYLCIeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYLCIeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYLCIdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:33:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLCIdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:33:51 -0500
Date: Wed, 3 Dec 2008 09:33:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
	output
Message-ID: <20081203083332.GA5455@elte.hu>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com> <20081203081906.GH21006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203081906.GH21006@elte.hu>
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


btw., i tested the graph tracer on a 16-way 64-bit box as well, and the 
multi-digit CPU field printout magic works fine there too:

  9)               |    pick_next_task() {
  9)   0.283 us    |      pick_next_task_fair();
  9)   0.276 us    |      pick_next_task_rt();
  9)   0.273 us    |      pick_next_task_fair();
  9)   0.279 us    |      pick_next_task_idle();
  9)   2.596 us    |    }
  9)   0.566 us    |    __lock_text_start();
 10)   0.299 us    |        }
 10)               |        mm_init() {
 10)               |          pgd_alloc() {
 10)               |            __get_free_pages() {
 10)               |              alloc_pages_current() {
 10)   0.330 us    |                policy_zonelist();
 10)               |                __alloc_pages_internal() {

	Ingo
