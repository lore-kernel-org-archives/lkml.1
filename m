Return-Path: <linux-kernel-owner+w=401wt.eu-S1763106AbZANPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106AbZANPLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZANPLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:11:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbZANPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:11:13 -0500
Date: Wed, 14 Jan 2009 10:11:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, rostedt@home.goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] sched: de CPP-ify the scheduler code
In-Reply-To: <20090114144624.11627.12938.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0901141009410.6759@gandalf.stny.rr.com>
References: <20090114144317.11627.69111.stgit@dev.haskins.net> <20090114144624.11627.12938.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 14 Jan 2009, Gregory Haskins wrote:

>  
> -#define enqueue_pushable_task(rq, p) do { } while (0)
> -#define dequeue_pushable_task(rq, p) do { } while (0)
> +static inline
> +void enqueue_pushable_task(struct rq *rq, struct task_struct *p) {}
> +static inline
> +void dequeue_pushable_task(struct rq *rq, struct task_struct *p) {}

Wouldn't the above look better as:

static inline void
enqueue_pushable_task(struct rq *rq, struct task_struct *p)
{
}
static inline void
dequeue_pushable_task(struct rq *rq, struct task_struct *p)
{
}


-- Steve

