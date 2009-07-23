Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZGWDo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZGWDo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZGWDo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:44:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZGWDo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:44:28 -0400
Date: Wed, 22 Jul 2009 23:44:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing: Fix seqfile memory leak for .31
In-Reply-To: <4A67D8CB.4040909@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907222344120.20997@gandalf.stny.rr.com>
References: <4A67D8CB.4040909@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Jul 2009, Li Zefan wrote:

> I found some memory leak in tracing code, due to missing
> seq_release().
> 
> I think those fixes should be queued for .31.

Thanks Li!

I'll get these queued up tomorrow.

-- Steve

> 
> [PATCH 1/3] trace_stack: Fix seqfile memory leak
> [PATCH 2/3] function-graph: Fix seqfile memory leak
> [PATCH 3/3] tracing/stat: Fix seqfile memory leak
> ---
>  kernel/trace/ftrace.c      |   15 ++++++++++++---
>  kernel/trace/trace_stack.c |    7 ++-----
>  kernel/trace/trace_stat.c  |   34 ++++++++++++++++++++++------------
>  3 files changed, 36 insertions(+), 20 deletions(-)
> 
> 
