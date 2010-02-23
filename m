Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0BWHiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:38:23 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39326 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0BWHiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:38:22 -0500
Message-ID: <4B83853B.3060700@monstr.eu>
Date: Tue, 23 Feb 2010 08:35:23 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][trivial] microblaze: Fix out_le32() macro
References: <1266852342-9033-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1266852342-9033-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added to next branch.

Thanks,
Michal

Steven J. Magnani wrote:
> Trailing semicolon causes compilation involving out_le32() to fail.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> diff -uprN a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
> --- a/arch/microblaze/include/asm/io.h	2010-02-22 09:21:14.000000000 -0600
> +++ b/arch/microblaze/include/asm/io.h	2010-02-22 09:21:44.000000000 -0600
> @@ -217,7 +217,7 @@ static inline void __iomem *__ioremap(ph
>   * Little endian
>   */
>  
> -#define out_le32(a, v) __raw_writel(__cpu_to_le32(v), (a));
> +#define out_le32(a, v) __raw_writel(__cpu_to_le32(v), (a))
>  #define out_le16(a, v) __raw_writew(__cpu_to_le16(v), (a))
>  
>  #define in_le32(a) __le32_to_cpu(__raw_readl(a))
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
