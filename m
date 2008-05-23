Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYEWOOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYEWOOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYEWOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:14:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56825 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYEWOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:14:27 -0400
Date: Fri, 23 May 2008 07:14:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] rcupreempt: remove export of rcu_batches_completed_bh
Message-ID: <20080523141403.GA8798@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.58.0805221415330.14724@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805221415330.14724@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 02:18:17PM -0400, Steven Rostedt wrote:
> 
> In rcupreempt, rcu_batches_completed_bh is defined as a static inline in
> the header file. This does not need to be exported, and not only that,
> this breaks my PPC build.

Good catch!!!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/rcupreempt.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-tip.git/kernel/rcupreempt.c
> ===================================================================
> --- linux-tip.git.orig/kernel/rcupreempt.c	2008-05-22 11:12:30.000000000 -0700
> +++ linux-tip.git/kernel/rcupreempt.c	2008-05-22 11:12:33.000000000 -0700
> @@ -217,8 +217,6 @@ long rcu_batches_completed(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_batches_completed);
> 
> -EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
> -
>  void __rcu_read_lock(void)
>  {
>  	int idx;
> 
