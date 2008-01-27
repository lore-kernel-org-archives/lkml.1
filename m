Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYA0LRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYA0LRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYA0LRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:17:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36319 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYA0LRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:17:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479C6821.1000405@s5r6.in-berlin.de>
Date: Sun, 27 Jan 2008 12:16:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: preemptible RCU bug (was Re: [git pull] scheduler changes for
 v2.6.25)
References: <20080125203740.GA31784@elte.hu> <479B87B9.8080005@s5r6.in-berlin.de> <20080127110559.GB28315@linux.vnet.ibm.com>
In-Reply-To: <20080127110559.GB28315@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> --- linux-2.6.24-rt1/kernel/Kconfig.preempt	2008-01-27 02:52:36.000000000 -0800
> +++ linux-2.6.24-rt1-RCUconfighelp/kernel/Kconfig.preempt	2008-01-27 03:05:22.000000000 -0800
> @@ -131,6 +131,14 @@ choice
>  	prompt "RCU implementation type:"
>  	default PREEMPT_RCU if PREEMPT_RT
>  	default CLASSIC_RCU
> +	help
> +	  This allows you to choose either the classic RCU implementation
> +	  that is designed for best read-side performance on non-realtime
> +	  systems, or the preemptible RCU implementation for best latency
> +	  on realtime systems.  Note that some kernel preemption modes
> +	  will restrict your choice.
> +
> +	  Select the default if you are unsure.

Looks good to me.  Serves those people who want to be informed as well
as those who want to be comforted.  :-)  Thanks,
-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/
