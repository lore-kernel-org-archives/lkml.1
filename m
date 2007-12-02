Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXLBGmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXLBGmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 01:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXLBGmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 01:42:42 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:46174 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXLBGml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 01:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a4OeRG1OXMT6nMQfy6oII4Rrhq4q5B4zWYln5Sg8ou7++ZWflOph4LL7XeS6SsjOR+ZZzHDKstANsdEi2LB0vspQnyKxxo74l7Hv1gNaJtk5vijMJqDS39Yxv1/iBy6wQ+MTQp9ZjNElH+nII8i2Wy6mZm33eSf+OEcykczrkEc=
Message-ID: <386072610712012242i58e48aebk17fec7a87391a7fc@mail.gmail.com>
Date: Sun, 2 Dec 2007 14:42:40 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>, "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: blackfin compile error
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071202004204.GE15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071202004204.GE15974@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 2, 2007 8:42 AM, Adrian Bunk <bunk@kernel.org> wrote:
> It seems commit 5d448dd50712ae42f8176b5bb8db4703bef6f0f5 was incomplete:
>
> <--  snip  -->
>
> ...
>   CC      arch/blackfin/mach-bf537/boards/stamp.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: unknown field 'pin_req' specified in initializer

Yes, there is a SPI patch adding the field 'pin_req' in a Blackfin SPI
header file which is in -mm tree.

David, could you please submit the Blackfin SPI update to mainline?

> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: extra brace group at end of initializer
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: (near initialization for 'bfin_spi0_info')
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: warning: excess elements in struct initializer
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: warning: (near initialization for 'bfin_spi0_info')
> make[2]: *** [arch/blackfin/mach-bf537/boards/stamp.o] Error 1
>
> <--  snip  -->
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
