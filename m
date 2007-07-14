Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXGNRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXGNRPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757639AbXGNRPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:15:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:46580 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626AbXGNRPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:15:12 -0400
Date: Sat, 14 Jul 2007 21:16:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
Message-ID: <20070714171646.GB746@tv-sign.ru>
References: <20070714175733.194012000@chello.nl> <20070714175839.641246000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714175839.641246000@chello.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Peter Zijlstra wrote:
>
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.
> 
> This will be useful to minimize the amount of preemption disabling for the -rt
> patch. It will help leveraging improvements brought by the local_t types in
> asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> variables protected by migrate_disable must be either atomic or protected from
> concurrent updates done by other threads.
> 
> Typical use:
> 
> migrate_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migrate_enable();
> 
> Which will increment the variable atomically wrt the local CPU.

I still think this patch is buggy. Perhaps I am wrong. Please look at

	http://marc.info/?l=linux-kernel&m=118417177818825

there was no any reply.

Oleg.

