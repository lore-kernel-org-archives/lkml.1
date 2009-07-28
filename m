Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZG1QzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZG1QzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZG1QzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:55:25 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1169 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZG1QzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:55:24 -0400
Subject: Re: [PATCH 1/2] IPVS: use pr_fmt
From: Joe Perches <joe@perches.com>
To: Hannes Eder <heder@google.com>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20090728160536.12503.82355.stgit@jazzy.zrh.corp.google.com>
References: <20090728160145.12503.61834.stgit@jazzy.zrh.corp.google.com>
	 <20090728160536.12503.82355.stgit@jazzy.zrh.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 09:55:20 -0700
Message-Id: <1248800120.6163.74.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 18:06 +0200, Hannes Eder wrote:
> While being at it cleanup whitespace.
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index e01cc2d..99f09ab 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -99,47 +99,47 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>  	return &buf[*idx - len];
>  }
>  
> -#define IP_VS_DBG_BUF(level, msg...)			\
> -    do {						\
> -	    char ip_vs_dbg_buf[160];			\
> -	    int ip_vs_dbg_idx = 0;			\
> -	    if (level <= ip_vs_get_debug_level())	\
> -		    printk(KERN_DEBUG "IPVS: " msg);	\
> -    } while (0)
[]
> +#define IP_VS_DBG_BUF(level, msg...)				\
> +	do {							\
> +		char ip_vs_dbg_buf[160];			\
> +		int ip_vs_dbg_idx = 0;				\
> +		if (level <= ip_vs_get_debug_level())		\
> +			pr_debug(msg);				\

I think you should keep printk(KERN_DEBUG...) here and elsewhere.
Unless DEBUG is #defined, this won't print anything.


