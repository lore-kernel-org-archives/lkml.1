Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbZLFKlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbZLFKlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933241AbZLFKlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:41:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189AbZLFKlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:41:11 -0500
Subject: Re: [PATCH 6/9] perf: Remove the "event" callback from perf events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1260084898-11686-7-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
	 <1260084898-11686-7-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 11:40:28 +0100
Message-ID: <1260096028.7818.262.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 08:34 +0100, Frederic Weisbecker wrote:
> As it is not used anymore and has been superseded by overflow_handler.

Thanks!

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d2f2667..89098e3 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -567,7 +567,6 @@ struct perf_pending_entry {
>  
>  struct perf_sample_data;
>  
> -typedef void (*perf_callback_t)(struct perf_event *, void *);
>  typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
>  					struct perf_sample_data *,
>  					struct pt_regs *regs);
> @@ -669,8 +668,6 @@ struct perf_event {
>  	struct event_filter		*filter;
>  #endif
>  
> -	perf_callback_t			callback;
> -
>  #endif /* CONFIG_PERF_EVENTS */
>  };
>  


