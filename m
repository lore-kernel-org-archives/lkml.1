Return-Path: <linux-kernel-owner+w=401wt.eu-S1763849AbZEHXP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763849AbZEHXP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZEHXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:15:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbZEHXPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:15:20 -0400
Date: Fri, 8 May 2009 16:10:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: [PATCH 1/5] hrtimer: per-cpu cached values of ktime
Message-Id: <20090508161034.d1bad204.akpm@linux-foundation.org>
In-Reply-To: <20090508170028.630419454@chello.nl>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.630419454@chello.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 18:52:20 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> --- linux-2.6.orig/include/linux/hrtimer.h
> +++ linux-2.6/include/linux/hrtimer.h
> @@ -173,8 +173,13 @@ struct hrtimer_cpu_base {
>  	int				hres_active;
>  	unsigned long			nr_events;
>  #endif
> +	ktime_t				ktime_irq;
> +	int				ktime_irq_set;
>  };

struct hrtimer_cpu_base has nice kerneldoc which (used to) describe
its fields.

Please please please always always always comment data structures.  The
bang-for-your-comment-buck is higher than anywhere else.

