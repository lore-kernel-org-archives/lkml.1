Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbXJMUfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbXJMUfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 16:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbXJMUf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 16:35:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:37700 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbXJMUf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 16:35:27 -0400
Message-ID: <fa686aa40710131335y710cf6edy59a46d365b1d6d67@mail.gmail.com>
Date: Sat, 13 Oct 2007 14:35:26 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] missing includes in arch/powerpc/platforms/52xx/lite5200.c
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071013184008.GL8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071013184008.GL8181@ftp.linux.org.uk>
X-Google-Sender-Auth: 004b36ce1b78b30f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Nak, this patch should be used to fix it instead.  A change to
lite5200 got dropped during merging.

http://patchwork.ozlabs.org/linuxppc/patch?id=14077

Cheers,
g.

> ---
> diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
> index 0caa3d9..774f249 100644
> --- a/arch/powerpc/platforms/52xx/lite5200.c
> +++ b/arch/powerpc/platforms/52xx/lite5200.c
> @@ -18,6 +18,8 @@
>  #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/of.h>
> +#include <linux/root_dev.h>
> +#include <linux/initrd.h>
>  #include <asm/time.h>
>  #include <asm/io.h>
>  #include <asm/machdep.h>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
