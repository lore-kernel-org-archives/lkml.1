Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZAMWs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZAMWs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZAMWsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:48:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:43425 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752785AbZAMWsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:48:46 -0500
Date: Tue, 13 Jan 2009 23:48:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Kaibin Li <kaibinlee@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: trivial@kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove a duplicated option of RCU_CPU_STALL_DETECTOR
In-Reply-To: <20090113140636.1515e11f@zenwalk.fortinet.com>
Message-ID: <alpine.LNX.1.10.0901132346150.5377@jikos.suse.cz>
References: <20090113140636.1515e11f@zenwalk.fortinet.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Kaibin Li wrote:

> There is a duplicated option of "Check for stalled CPUs delaying RCU
> grace periods" in Kernel hacking.
> 
> Signed-off-by: Kaibin Li <kaibinlee@gmail.com>
> ---
>  lib/Kconfig.debug |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 4c9ae60..e770e85 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -633,19 +633,6 @@ config RCU_TORTURE_TEST_RUNNABLE
>  
>  config RCU_CPU_STALL_DETECTOR
>     bool "Check for stalled CPUs delaying RCU grace periods"
> -   depends on CLASSIC_RCU
> -   default n
> -   help
> -     This option causes RCU to printk information on which
> -     CPUs are delaying the current grace period, but only when
> -     the grace period extends for excessive time periods.
> -
> -     Say Y if you want RCU to perform such checks.
> -
> -     Say N if you are unsure.
> -
> -config RCU_CPU_STALL_DETECTOR
> -   bool "Check for stalled CPUs delaying RCU grace periods"
>     depends on CLASSIC_RCU || TREE_RCU
>     default n
>     help

The RCU_CPU_STALL_DETECTOR indeed is duplicate, but the entries themselves 
are not identical, as they have different dependencies.

Paul -- does Kaibin's patch remove the correct one? If so, I can take it 
through trivial tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
