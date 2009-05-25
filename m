Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZEYDbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZEYDbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZEYDbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:31:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZEYDbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:31:09 -0400
Date: Mon, 25 May 2009 05:30:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/X] ptrace: introduce the empty "struct
	ptrace_task"
Message-ID: <20090525032426.GA20687@elte.hu>
References: <20090525000001.GA2218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525000001.GA2218@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> --- PTRACE/include/linux/sched.h~3_STRUCT	2009-05-24 21:29:04.000000000 +0200
> +++ PTRACE/include/linux/sched.h	2009-05-24 22:14:41.000000000 +0200
> @@ -1201,6 +1201,7 @@ struct task_struct {
>  	struct list_head sibling;	/* linkage in my parent's children list */
>  	struct task_struct *group_leader;	/* threadgroup leader */
>  
> +	struct ptrace_task *ptrace_task;
>  	/*
>  	 * ptraced is the list of tasks this task is using ptrace on.
>  	 * This includes both natural children and PTRACE_ATTACH targets.

the naming sucks.

Please use 'struct ptrace_context' and '*ptrace_ctx' instead.

Thanks,

	Ingo
