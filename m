Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZLVTHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZLVTHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZLVTHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:07:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44912 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZLVTHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YJ+Uhm5BsWoJlVuBZOIyHkMH/K8xqQAYOtes+8qlM//PvN/E0UzU4oPy/laQYftOIE
         S3KDttgd4rijKztfLXpB71UjiPWAmqU1TIsc/tnMG16+7zxoYTNQLtqZ1CwjWGUdv72Q
         myqCtbFfmtLJy798Qm2wyLsJXd27MsfQwNzdQ=
MIME-Version: 1.0
In-Reply-To: <20091022140717.GB27903@frolo.macqel>
References: <20091022135454.GA27903@frolo.macqel>
	 <20091022140717.GB27903@frolo.macqel>
Date: Tue, 22 Dec 2009 20:07:16 +0100
X-Google-Sender-Auth: 35a82647c21f466b
Message-ID: <10f740e80912221107ocae38b6v424d7d771f2ecf52@mail.gmail.com>
Subject: Re: [PATCH] cleanup remove obsolete comment about map_chunk
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 15:07, Philippe De Muyter <phdm@macqel.be> wrote:
> Remove the comments referring to a function map_chunk that no longer exists.

Thanks!

I'll take it through the m68k tree. The h8300 case was copied from m68k anyway.

> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>
> diff --git a/arch/h8300/mm/memory.c b/arch/h8300/mm/memory.c
> --- a/arch/h8300/mm/memory.c
> +++ b/arch/h8300/mm/memory.c

> @@ -44,8 +44,8 @@ void cache_push_v (unsigned long vaddr,
>  {
>  }
>
> -/* Map some physical address range into the kernel address space. The
> - * code is copied and adapted from map_chunk().
> +/*
> + * Map some physical address range into the kernel address space.
>  */
>
>  unsigned long kernel_map(unsigned long paddr, unsigned long size,
> diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
> --- a/arch/m68k/mm/kmap.c
> +++ b/arch/m68k/mm/kmap.c
> @@ -99,8 +99,7 @@ static inline void free_io_area(void *ad
>  #endif
>
>  /*
> - * Map some physical address range into the kernel address space. The
> - * code is copied and adapted from map_chunk().
> + * Map some physical address range into the kernel address space.
>  */
>  /* Rewritten by Andreas Schwab to remove all races. */
>
> diff --git a/arch/m68knommu/mm/memory.c b/arch/m68knommu/mm/memory.c
> --- a/arch/m68knommu/mm/memory.c
> +++ b/arch/m68knommu/mm/memory.c
> @@ -24,7 +24,6 @@
>
>  /*
>  * Map some physical address range into the kernel address space.
> - * The code is copied and adapted from map_chunk().
>  */
>
>  unsigned long kernel_map(unsigned long paddr, unsigned long size,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
