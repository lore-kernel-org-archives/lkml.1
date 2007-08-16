Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbXHPJUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbXHPJUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXHPJUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:20:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12516 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXHPJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ArAT4HDqjnpRWwcNgxSJSOHA21tkX1m0Y2Ao+4oWOox+AgmdLDUm8SWiXts1rTERwvRwZIcRAUOyAQniai7QpxzsIhv2kXN3fhaK/OjTzSEELdKiTtw6cUP7iuvVb1PCQgz0ZWN00bRoc3pROgpZJFnBPudw08P9hF75gk56Lps=
Message-ID: <653402b90708160220s18637818rb52dec9d8e904ada@mail.gmail.com>
Date: Thu, 16 Aug 2007 11:20:00 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [80/2many] MAINTAINERS - AUXILIARY DISPLAY DRIVERS
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bff8fa.jPPVBOEkQ5RmiYoK%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff8fa.jPPVBOEkQ5RmiYoK%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0042bf6..9e28325 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -808,6 +808,8 @@ M:  maxextreme@gmail.com
>  L:     linux-kernel@vger.kernel.org
>  W:     http://auxdisplay.googlepages.com/
>  S:     Maintained
> +F:     drivers/auxdisplay/
> +F:     include/linux/cfag12864b.h
>
>  AVR32 ARCHITECTURE
>  P:     Haavard Skinnemoen
>

Although for now drivers/auxdisplay/ only supports 2*ks0108-controlled
LCDs like cfag12864b or similar,

> +F:     include/linux/cfag12864b.h

it is not really just about cfag12864b (although it could be OK to
point to some header file at all).

Thank you for the patch.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
