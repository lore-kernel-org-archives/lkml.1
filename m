Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZIZTzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZIZTzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZIZTzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:55:38 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37711 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbZIZTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:55:37 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2009 15:55:37 EDT
X-IronPort-AV: E=Sophos;i="4.44,457,1249250400"; 
   d="scan'208";a="33602997"
Message-ID: <4ABE6F3A.9000901@ens-lyon.org>
Date: Sat, 26 Sep 2009 21:44:58 +0200
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix CONFIG_NUMA help message
References: <20090926181837.GA15018@basil.fritz.box>
In-Reply-To: <20090926181837.GA15018@basil.fritz.box>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Noticed recently while looking at this file. The x86 NUMA Kconfig help
> entry is not quite correct.
>
> - Core i7 systems are always non NUMA. Refer to multi socket Nehalems instead.
> - Replace outdated EM64T term with Intel 64
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/Kconfig |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 384a897..47c81bd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1118,8 +1118,9 @@ config NUMA
>  	  local memory controller of the CPU and add some more
>  	  NUMA awareness to the kernel.
>  
> -	  For 64-bit this is recommended if the system is Intel Core i7
> -	  (or later), AMD Opteron, or EM64T NUMA.
> +	  For 64-bit this is recommended if the system is Intel Xeon 75xx
> +	  (Intel Nehalem based multi socket systems), AMD Opteron, or Intel
> +          64 NUMA.
>  
>  	  For 32-bit this is only needed on (rare) 32-bit-only platforms
>  	  that support NUMA topologies, such as NUMAQ / Summit, or if you
>   

Why Xeon 75xx and not 55xx ?

Brice

