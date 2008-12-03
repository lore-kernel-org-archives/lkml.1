Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYLCKWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYLCKWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYLCKVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:21:52 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:61568 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYLCKVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:21:51 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
 output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530812030207l75084154vf1f94fe22ab0448@mail.gmail.com>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
	 <20081203081906.GH21006@elte.hu> <20081203083332.GA5455@elte.hu>
	 <c62985530812030207l75084154vf1f94fe22ab0448@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Dec 2008 11:21:46 +0100
Message-Id: <1228299706.9673.115.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 11:07 +0100, Frédéric Weisbecker wrote:
> 
> 
> >
> > btw., i tested the graph tracer on a 16-way 64-bit box as well, and
> the
> > multi-digit CPU field printout magic works fine there too:
> >
> >  9)               |    pick_next_task() {
> >  9)   0.283 us    |      pick_next_task_fair();
> >  9)   0.276 us    |      pick_next_task_rt();
> >  9)   0.273 us    |      pick_next_task_fair();
> >  9)   0.279 us    |      pick_next_task_idle();
> >  9)   2.596 us    |    }
> >  9)   0.566 us    |    __lock_text_start();
> >  10)   0.299 us    |        }
> >  10)               |        mm_init() {
> >  10)               |          pgd_alloc() {
> >  10)               |            __get_free_pages() {
> >  10)               |              alloc_pages_current() {
> >  10)   0.330 us    |                policy_zonelist();
> >  10)               |                __alloc_pages_internal() {
> >
> >        Ingo
> >
> 
> Hmm not really, there should be one space more before the 9 to fit the
> log10(MAX_CPU) here and not break
> the column.

It did in my copy of Ingo's email...

