Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYKUXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYKUXYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYKUXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:24:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbYKUXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:24:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=d0PjVOiXzBW4C7VaC+bbWYoASOQexSG0t+YVO361dkGVV9nfsheOQMeTiIST5L4Ay
	cIY99qtwR9GjNGGkDo91w==
Date: Fri, 21 Nov 2008 15:24:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ying Han <yinghan@google.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Rohit Seth <rohitseth@google.com>
Subject: Re: Make the get_user_pages interruptible
In-Reply-To: <604427e00811201403k26e4bf93tdb2dee9506756a82@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0811211520450.16413@chino.kir.corp.google.com>
References: <604427e00811201403k26e4bf93tdb2dee9506756a82@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, Ying Han wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b483f39..f2a5cac 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1795,6 +1795,7 @@ extern void flush_signals(struct task_struct *);
>  extern void ignore_signals(struct task_struct *);
>  extern void flush_signal_handlers(struct task_struct *, int force_default);
>  extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t
> +extern int sigkill_pending(struct task_struct *tsk);
> 
>  static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask
>  {

I can't git apply this because it appears as though your email client has 
truncated long lines (see dequeue_signal above).

Your headers look like you're using the gmail GUI to send patches, and 
that client has its own section in Documentation/email-clients.txt.  If 
the instructions don't happen to work for you, please fix that section 
once you've troubleshooted the problem.
