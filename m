Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbXJYCsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbXJYCsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXJYCry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:47:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:46132 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXJYCrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MS5CB1CK2KdNbSlji5Ajb+tcTM56INlHVzEe1tmarQWWPGiGmBvZlulF3Xzai1R9n6EpzufGg4c3wPHRQkXv8kugB8trtfhFHVC+zjUGwxpjAZMDbnFURt4s9CATWyj4wPAgf+XcVoSPm/nAoSA4p4GeglheKWy3RVnO4OJ4cKQ=
Message-ID: <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>
Date: Thu, 25 Oct 2007 10:47:50 +0800
From: "Jie Zhang" <jzhang.linux@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162643.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162643.GP30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> "extern inline" will have different semantics with gcc 4.3.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> --- a/include/asm-blackfin/string.h
> +++ b/include/asm-blackfin/string.h
> @@ -4,7 +4,7 @@
>  #ifdef __KERNEL__              /* only set these up for kernel code */
>
>  #define __HAVE_ARCH_STRCPY
> -extern inline char *strcpy(char *dest, const char *src)
> +static inline char *strcpy(char *dest, const char *src)
>  {
>         char *xdest = dest;
>         char temp = 0;

What if we compile it with gcc 4.1?


Jie
