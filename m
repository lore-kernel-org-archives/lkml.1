Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbXBYI7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbXBYI7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933684AbXBYI7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:59:20 -0500
Received: from www.osadl.org ([213.239.205.134]:37259 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933683AbXBYI7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:59:19 -0500
Subject: Re: [PATCH]: tick-sched.c build fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Miller <davem@davemloft.net>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, peter.keilty@hp.com
In-Reply-To: <20070224.214201.126577744.davem@davemloft.net>
References: <20070224.214201.126577744.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 10:04:41 +0100
Message-Id: <1172394281.25076.361.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 21:42 -0800, David Miller wrote:
> While getting dynticks/hrtimers up on sparc64 I ran into
> the following build problem.  If you use get_irq_regs() you
> need to include asm/irq_regs.h
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 512a4a9..51556b9 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -21,6 +21,8 @@
>  #include <linux/sched.h>
>  #include <linux/tick.h>
>  
> +#include <asm/irq_regs.h>
> +
>  #include "tick-internal.h"
>  
>  /*

