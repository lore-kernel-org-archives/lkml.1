Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZBPIJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZBPIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZBPIJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:09:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37465
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbZBPIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:09:50 -0500
Date: Mon, 16 Feb 2009 00:09:34 -0800 (PST)
Message-Id: <20090216.000934.65948249.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: replace commatas with semicolons
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
References: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 13 Feb 2009 22:46:21 +0100 (CET)

> Impact: syntax fix
> 
> Interestingly enough this compiles w/o any complaints:
> 
> 	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
> 	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied, please CC: netdev on future patches so that they
get properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

Thank you.

> ---
>  net/ipv4/proc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/net/ipv4/proc.c
> ===================================================================
> --- linux-2.6.orig/net/ipv4/proc.c
> +++ linux-2.6/net/ipv4/proc.c
> @@ -54,8 +54,8 @@ static int sockstat_seq_show(struct seq_
>  	int orphans, sockets;
>  
>  	local_bh_disable();
> -	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
> -	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),
> +	orphans = percpu_counter_sum_positive(&tcp_orphan_count);
> +	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated);
>  	local_bh_enable();
>  
>  	socket_seq_show(seq);
