Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZAGRTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZAGRTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZAGRSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:18:55 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56683 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZAGRSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:18:55 -0500
Date: Wed, 7 Jan 2009 09:18:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: mingo@linux.vnet.ibm.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: rcu: Make a seperate Kconfig menu for RCU
Message-ID: <20090107171851.GC6900@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090107171017.GA4145@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107171017.GA4145@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 10:40:17PM +0530, Dhaval Giani wrote:
> Hi Paul, Ingo,
> 
> On selecting tree RCU, there are a total of 4 different RCU Kconfig options.
> Maybe its time to give RCU a menu of its own.

Looks good to me!

Reviewed-by: Paul E. McKenneyh <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> ---
>  init/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/init/Kconfig
> ===================================================================
> --- linux-2.6.orig/init/Kconfig	2009-01-07 10:18:17.000000000 +0530
> +++ linux-2.6/init/Kconfig	2009-01-07 21:01:39.000000000 +0530
> @@ -945,6 +945,8 @@ source "block/Kconfig"
>  config PREEMPT_NOTIFIERS
>  	bool
> 
> +menu "RCU related options"
> +
>  choice
>  	prompt "RCU Implementation"
>  	default CLASSIC_RCU
> @@ -1032,3 +1034,5 @@ config PREEMPT_RCU_TRACE
>  	help
>  	  This option provides tracing for the PREEMPT_RCU implementation,
>  	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
> +
> +endmenu
> -- 
> regards,
> Dhaval
