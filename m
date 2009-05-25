Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZEYPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZEYPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZEYPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:55:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44232 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbZEYPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:55:16 -0400
Date: Mon, 25 May 2009 17:50:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/X] ptrace: introduce the empty "struct
	ptrace_task"
Message-ID: <20090525155038.GA10431@redhat.com>
References: <20090525000001.GA2218@redhat.com> <20090525032426.GA20687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525032426.GA20687@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > --- PTRACE/include/linux/sched.h~3_STRUCT	2009-05-24 21:29:04.000000000 +0200
> > +++ PTRACE/include/linux/sched.h	2009-05-24 22:14:41.000000000 +0200
> > @@ -1201,6 +1201,7 @@ struct task_struct {
> >  	struct list_head sibling;	/* linkage in my parent's children list */
> >  	struct task_struct *group_leader;	/* threadgroup leader */
> >
> > +	struct ptrace_task *ptrace_task;
> >  	/*
> >  	 * ptraced is the list of tasks this task is using ptrace on.
> >  	 * This includes both natural children and PTRACE_ATTACH targets.
>
> the naming sucks.
>
> Please use 'struct ptrace_context' and '*ptrace_ctx' instead.

As always, I agree with any naming. Will re-name in V2.

Oleg.

