Return-Path: <linux-kernel-owner+w=401wt.eu-S935976AbYBVAaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935976AbYBVAaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936017AbYBVA3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:29:50 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10536 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936011AbYBVA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:29:48 -0500
Message-ID: <47BE14FD.10401@oracle.com>
Date: Thu, 21 Feb 2008 16:19:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH 2.6.25-rc2 5/9] Kconfig: Improve init/Kconfig help descriptions
 - IKCONFIG etc
References: <20080219140609.GA26619@tull.net> <200802220014.m1M0Dh5r022354@rgminet03.oracle.com>
In-Reply-To: <200802220014.m1M0Dh5r022354@rgminet03.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> Rewrite the help descriptions for clarity, accuracy and consistency.
> 
> Kernel config options affected:
> 
>   - IKCONFIG
>   - IKCONFIG_PROC
>   - LOG_BUF_SHIFT

These bits are Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> ---
> Try #3.
> 
> --- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
> +++ b/init/Kconfig	2008-02-22 09:15:48.000000000 +1100
> @@ -241,20 +241,30 @@ config IKCONFIG
>  	tristate "Kernel .config support"
>  	---help---
>  	  This option enables the complete Linux kernel ".config" file
> -	  contents to be saved in the kernel. It provides documentation
> -	  of which kernel options are used in a running kernel or in an
> -	  on-disk kernel.  This information can be extracted from the kernel
> -	  image file with the script scripts/extract-ikconfig and used as
> -	  input to rebuild the current kernel or to build another kernel.
> -	  It can also be extracted from a running kernel by reading
> -	  /proc/config.gz if enabled (below).
> +	  contents to be saved in the kernel.
> +
> +	  It provides documentation of which kernel options are used in
> +	  a running kernel or in an on-disk kernel.  This information
> +	  can be extracted from the kernel image file with the script
> +	  "scripts/extract-ikconfig" and used as input to rebuild the
> +	  current kernel or to build another kernel.
> +
> +	  It can also be extracted from a running kernel with
> +	  "zcat /proc/config.gz" if CONFIG_IKCONFIG_PROC is enabled
> +	  below.
> +
> +	  Your kernel size will increase by around 14k.
> +
> +	  If unsure, say N.
>  
>  config IKCONFIG_PROC
>  	bool "Enable access to .config through /proc/config.gz"
>  	depends on IKCONFIG && PROC_FS
>  	---help---
> -	  This option enables access to the kernel configuration file
> -	  through /proc/config.gz.
> +	  This option enables access to the configuration of the running
> +	  kernel through /proc/config.gz.
> +
> +	  If unsure, say Y.
>  
>  config LOG_BUF_SHIFT
>  	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
> @@ -264,14 +274,15 @@ config LOG_BUF_SHIFT
>  	default 15 if SMP
>  	default 14
>  	help
> -	  Select kernel log buffer size as a power of 2.
> -	  Defaults and Examples:
> +	  Select the kernel log buffer size as a power of 2.
> +
> +	  Defaults and examples:
>  	  	     17 => 128 KB for S/390
> -		     16 => 64 KB for x86 NUMAQ or IA-64
> -	             15 => 32 KB for SMP
> -	             14 => 16 KB for uniprocessor
> -		     13 =>  8 KB
> -		     12 =>  4 KB
> +		     16 =>  64 KB for x86 NUMAQ or IA-64
> +	             15 =>  32 KB for SMP
> +	             14 =>  16 KB for uniprocessor
> +		     13 =>   8 KB
> +		     12 =>   4 KB
>  
>  config CGROUPS
>  	bool "Control Group support"


-- 
~Randy
