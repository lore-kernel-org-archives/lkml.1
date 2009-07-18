Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZGRLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZGRLaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbZGRLa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:30:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062AbZGRLa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:30:28 -0400
Date: Sat, 18 Jul 2009 13:29:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: use defined fields to print formats
Message-ID: <20090718112928.GF27287@elte.hu>
References: <4A5F38F9.7060002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5F38F9.7060002@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> It seems that ftrace_format_##call() and 
> ftrace_define_fields_##call() are duplicate more or less.
> 
> trace_define_field() defines fields and links them into strcut 
> ftrace_event_call. We reuse them to print formats and remove 
> ftrace_format_##call(). It make all things simpler.
> 
> TRACE_EVENT_FORMAT_NOFILTER is dropped. Because we should 
> "trace_define_field()" fields for all struct ftrace_event_call, 
> even it's no filter.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5c093ff..738b33d 100644

Minor request for future patches: could you please include the 
diffstat all the time? Makes it much easier to see the general 
impact of a patch.

	Ingo
