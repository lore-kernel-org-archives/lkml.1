Return-Path: <linux-kernel-owner+w=401wt.eu-S1946819AbXD3U7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946819AbXD3U7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946820AbXD3U7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:59:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56512 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946819AbXD3U7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:59:07 -0400
Date: Mon, 30 Apr 2007 14:02:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch] pm: include EIO from errno-base.h
Message-Id: <20070430140238.ff65e3e0.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0704301215190.17664@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704291700220.1822@chino.kir.corp.google.com>
	<200704300751.07078.david-b@pacbell.net>
	<Pine.LNX.4.64.0704301215190.17664@chino.kir.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 12:15:57 -0700 (PDT) David Rientjes wrote:

> For backwards compatibility, call_platform_enable_wakeup() can return 0 
> instead of -EIO since we aren't guaranteed to have errno defined.
> 
> Cc: David Brownell <david-b@pacbell.net>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/pm.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -328,7 +328,7 @@ static inline void dpm_runtime_resume(struct device * dev)
>  
>  static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
>  {
> -	return -EIO;
> +	return 0;
>  }
>  
>  #endif


Andrew,
Can you fasttrack this one?  otherwise allnoconfig fails.  :(

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
