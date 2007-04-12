Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXDLMwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXDLMwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXDLMwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:52:39 -0400
Received: from anchor-fallback-93.mail.demon.net ([194.217.242.93]:45861 "EHLO
	anchor-fallback-93.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbXDLMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:52:38 -0400
X-Greylist: delayed 4295 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 08:52:38 EDT
Message-ID: <461E1AC9.30107@lougher.demon.co.uk>
Date: Thu, 12 Apr 2007 12:40:57 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Nate Diller <nate.diller@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 7/17] jffs2: convert jffs2_gc_fetch_page to read_cache_page
References: <20070412024938.27380.13619.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.13619.patchbomb.py@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nate Diller wrote:

> +	page = read_cache_page(OFNI_EDONI_2SFFJ(f)->i_mapping,
> +				start >> PAGE_CACHE_SHIFT,
> +				(void *)jffs2_do_readpage_unlock,
> +				OFNI_EDONI_2SFFJ(f));
>  
> -	if (IS_ERR(pg_ptr)) {
> +	if (IS_ERR(page)) {
>  		printk(KERN_WARNING "read_cache_page() returned error: %ld\n", PTR_ERR(pg_ptr));

should be

   		printk(KERN_WARNING "read_cache_page() returned error: %ld\n", PTR_ERR(page));

> -		return PTR_ERR(pg_ptr);
> +		return PTR_ERR(page);
