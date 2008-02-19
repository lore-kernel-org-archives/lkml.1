Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYBSOnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYBSOnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYBSOm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:42:58 -0500
Received: from sacred.ru ([62.205.161.221]:58051 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYBSOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:42:58 -0500
Message-ID: <47BAEABF.6050005@openvz.org>
Date: Tue, 19 Feb 2008 17:42:07 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 3/9]
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net>
In-Reply-To: <20080219143307.GA27352@tull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 19 Feb 2008 17:42:05 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
>> Here is a series of 9 patches to init/Kconfig intended to improve the
>> usefulness and consistency of the help descriptions. The patches are
>> against linux-2.6.24.2.
>> [...]
>> Patch 3
>> 	USER_NS
>> 	PID_NS

What about UTS_NS, IPC_NS and NET_NS? 
Their descriptions can be improved in the same way :)

> Changelog:
> 
> Improve usefulness and consistency of kernel configuration help messages.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> 
> --- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
> +++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
> @@ -211,21 +211,25 @@ config USER_NS
>  	default n
>  	depends on EXPERIMENTAL
>  	help
> -	  Support user namespaces.  This allows containers, i.e.
> -	  vservers, to use user namespaces to provide different
> -	  user info for different servers.  If unsure, say N.
> +	  Enable support for user namespaces.
> +
> +	  This allows containers (i.e. vservers) to use user namespaces
> +	  to provide different user info for different servers.
> +
> +	  If unsure, say N.
>  
>  config PID_NS
>  	bool "PID Namespaces (EXPERIMENTAL)"
>  	default n
>  	depends on EXPERIMENTAL
>  	help
> -	  Suport process id namespaces.  This allows having multiple
> -	  process with the same pid as long as they are in different
> -	  pid namespaces.  This is a building block of containers.
> +	  Enable support for process id namespaces.
>  
> -	  Unless you want to work with an experimental feature
> -	  say N here.
> +	  This allows having multiple processes with the same PID as
> +	  long as they are in different PID namespaces.  This is used
> +	  by containers (i.e. vservers).
> +
> +	  If unsure, say N.
>  
>  config AUDIT
>  	bool "Auditing support"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

