Return-Path: <linux-kernel-owner+w=401wt.eu-S1945952AbXBBPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952AbXBBPty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945937AbXBBPty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:49:54 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46631 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945952AbXBBPtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:49:53 -0500
Date: Fri, 2 Feb 2007 07:49:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       dipankar@in.ibm.com
Subject: Re: [PATCH -mm] Make rcupreempt.c compile with CONFIG_RCU_TRACE not set
Message-ID: <20070202154945.GA4732@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200701300131.36485.fzu@wemgehoertderstaat.de> <20070201020619.GU2574@linux.vnet.ibm.com> <200702011106.13836.fzu@wemgehoertderstaat.de> <200702020448.03256.fzu@wemgehoertderstaat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702020448.03256.fzu@wemgehoertderstaat.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 04:48:02AM +0100, Karsten Wiese wrote:
> 
> RCU_TRACE is always defined.

Good catch!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
> 
> ---
> diff -pur rc6-mm2/kernel/rcupreempt.c rc6-mm2-kw/kernel/rcupreempt.c
> --- rc6-mm2/kernel/rcupreempt.c	2007-01-30 00:08:21.000000000 +0100
> +++ rc6-mm2-kw/kernel/rcupreempt.c	2007-01-29 11:07:43.000000000 +0100
> @@ -619,7 +619,7 @@ void synchronize_kernel(void)
>  	synchronize_rcu();
>  }
> 
> -#ifdef RCU_TRACE
> +#ifdef CONFIG_RCU_TRACE
>  int *rcupreempt_flipctr(int cpu)
>  {
>  	return &per_cpu(rcu_flipctr, cpu)[0];
