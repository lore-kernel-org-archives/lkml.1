Return-Path: <linux-kernel-owner+w=401wt.eu-S936254AbXGRSwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936254AbXGRSwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbXGRSwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:52:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017AbXGRSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=Lis8S+nshrmcNKrmh/e7gb5+NmnnlBEm7pCu6xlcgADvIfTfeAKcpU1L9ySXdW39cqM9zR1EFII5UA0o2pm2dZw9jwp+OwiC6zm+drDUVVzpXypnbl2aGtxVpkcdgZEYvRBAxwgqtZhS9d4YJQVkj5AgiiLYJloM73+0UwAji00=
Date: Wed, 18 Jul 2007 22:52:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: adobriyan@sw.ru, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert part of 3f1b0e1f287547903f11fa1e6de7d2765597766e
Message-ID: <20070718185211.GA5575@martell.zuzino.mipt.ru>
References: <200707182103.13500.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707182103.13500.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 09:03:13PM +0300, S.Çağlar Onur wrote:
> With 3f1b0e1f287547903f11fa1e6de7d2765597766e Linus's current git tree starts 
> to ignore any *.orig or *.rej files (for example "git status" cannot show 
> what are they) but if there are some *.orig or *.rej files exists, for 
> whatever reason, that means some unresolved merge conflicts occured for that 
> code tree and this tree is no longer trusted so better not to ignore these.

*.orig are generated even if line numbers change a bit, so untrusted is
a somewhat exaggerated.

> --- a/.gitignore
> +++ b/.gitignore
> @@ -45,6 +45,3 @@ series
>  
>  # cscope files
>  cscope.*
> -
> -*.orig
> -*.rej

