Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXKGS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXKGS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXKGS2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:28:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbXKGS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:28:31 -0500
Date: Wed, 7 Nov 2007 10:27:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, pwil3058@bigpond.net.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
Message-Id: <20071107102725.64514fde.akpm@linux-foundation.org>
In-Reply-To: <1194437820.6289.114.camel@twins>
References: <1194434956.6289.111.camel@twins>
	<1194437820.6289.114.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 07 Nov 2007 13:17:00 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "sched_nr_migrate",
> +		.data		= &sysctl_sched_nr_migrate,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 644,
> +		.proc_handler	= &proc_dointvec,
> +	},

This (and all the other stuff in that table) should be described in
Documentation/, please.

It would be nice if sched_nr_migrate didn't exist, really.  It's hard to
imagine anyone wanting to tweak it, apart from developers.
