Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0BYEAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:00:40 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58960 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0BYEAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DrWsNN0ZeHHdlCECWiWDyhtrs6/xoUE2bkqcGr5FsNeTSb61hcQQ37vG98YixjtqyJ
         e6sLWBh+Ss+dUMtdi4ve3brXDvT5Gru1tArEvFOkL7PODkMvrrdCev/DAiE+h33hGXiB
         9m5TZNxB4XBDdAPzzHNWUle742PNL2UIKRsv8=
Date: Thu, 25 Feb 2010 05:00:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Remove CONFIG_TRACE_POWER from kernel config
Message-ID: <20100225040035.GE7491@nowhere>
References: <4B84D50E.4070806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B84D50E.4070806@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:28:14PM +0800, Li Zefan wrote:
> The power tracer has been converted to power trace events.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/Kconfig |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 928b289..745d01c 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -341,15 +341,6 @@ config BRANCH_TRACER
>  
>  	  Say N if unsure.
>  
> -config POWER_TRACER
> -	bool "Trace power consumption behavior"
> -	depends on X86
> -	select GENERIC_TRACER
> -	help
> -	  This tracer helps developers to analyze and optimize the kernel's
> -	  power management decisions, specifically the C-state and P-state
> -	  behavior.
> -
>  config KSYM_TRACER
>  	bool "Trace read and write access on kernel memory locations"
>  	depends on HAVE_HW_BREAKPOINT
> -- 
> 1.6.3
> 

