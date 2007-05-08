Return-Path: <linux-kernel-owner+w=401wt.eu-S1032425AbXEHVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032425AbXEHVzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032078AbXEHVze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:55:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50525 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032076AbXEHVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:55:33 -0400
Date: Tue, 8 May 2007 14:56:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Arnaldo Carvalho de Melo <acme@mandriva.com>,
       Al Viro <viro@ftp.linux.org.uk>, Panagiotis Issaris <takis@issaris.org>
Subject: Re: [patch 1/4] add kstrndup
Message-Id: <20070508145653.25585885.randy.dunlap@oracle.com>
In-Reply-To: <20070508205517.009423792@goop.org>
References: <20070508205129.064843364@goop.org>
	<20070508205517.009423792@goop.org>
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

On Tue, 08 May 2007 13:51:30 -0700 Jeremy Fitzhardinge wrote:

> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -18,7 +18,7 @@ void *__kzalloc(size_t size, gfp_t flags
>  }
>  EXPORT_SYMBOL(__kzalloc);
>  
> -/*
> +/**
>   * kstrdup - allocate space for and copy an existing string

No blank ("*") line between function name and its parameters.
(occurs in multiple places in multiple patches in this series;
I'm not going to point out each one of them separately)

>   *
>   * @s: the string to duplicate
> @@ -39,6 +39,33 @@ char *kstrdup(const char *s, gfp_t gfp)
>  	return buf;
>  }
>  EXPORT_SYMBOL(kstrdup);
> +
> +/**
> + * kstrndup - allocate space for and copy an existing string
> + *
> + * @s: the string to duplicate
> + * @max: read at most @max chars from @s
> + * @gfp: the GFP mask used in the kmalloc() call when allocating memory
> + */
> +char *kstrndup(const char *s, size_t max, gfp_t gfp)
> +{
> +}
> +EXPORT_SYMBOL(kstrndup);
>  
>  /**
>   * kmemdup - duplicate region of memory
> ===================================================================

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
