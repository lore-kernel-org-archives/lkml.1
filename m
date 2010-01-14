Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134Ab0ANPIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab0ANPIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932248Ab0ANPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:07:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab0ANPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:06:52 -0500
X-Authority-Analysis: v=1.0 c=1 a=Nora_UQfvSMA:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=rzlYJIk-HrhOc_vsxusA:9 a=RkMuDUgsPLePwPGYVSm6vhM3HMsA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Drop the tr check from the graph tracing path
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1263453795-7496-1-git-send-regression-fweisbec@gmail.com>
References: <1263453795-7496-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 14 Jan 2010 10:06:49 -0500
Message-ID: <1263481609.28171.3845.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 08:23 +0100, Frederic Weisbecker wrote:
> Each time we save a function entry from the function graph tracer,
> we check if the trace array is set, which is wasteful because it is
> set anyway before we start the tracer. All we need is to ensure we
> have good read and write orderings. When we set the trace array, we
> just need to guarantee it to be visible before starting tracing.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_functions_graph.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)


