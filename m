Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbYAVKjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbYAVKjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYAVKi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:38:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44014 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbYAVKi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:38:58 -0500
Date: Tue, 22 Jan 2008 11:38:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mike Galbraith <efault@gmx.de>, Frederik Himpe <fhimpe@telenet.be>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Message-ID: <20080122103847.GB21149@elte.hu>
References: <1200949086.6648.19.camel@Anastacia> <200801221105.11413.nickpiggin@yahoo.com.au> <1200978207.3944.8.camel@homer.simson.net> <200801221625.58615.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801221625.58615.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -4920,8 +4920,7 @@ static void show_task(struct task_struct
>  	printk(KERN_CONT "%5lu %5d %6d\n", free,
>  		task_pid_nr(p), task_pid_nr(p->real_parent));
>  
> -	if (state != TASK_RUNNING)
> -		show_stack(p, NULL);
> +	show_stack(p, NULL);

thanks - applied to sched-devel.git. We'll see whether it causes any 
problems.

	Ingo
