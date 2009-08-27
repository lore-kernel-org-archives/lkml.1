Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZH0MZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZH0MZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZH0MZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:25:27 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:50374 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZH0MZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FO77S/Orz/V1Pu1ceEYwnW3Ave+OQA2FRYHrzeUJuF0RhCsE6tdjLBpdVo+18ebH1W
         GmIQBg++ds7rvSBDio5F40tAWEt0KZTRkRe++dvFkgf4NYeuR7DMz+0LkpDtxEMUos8c
         YIxB8sVy4WHPnrPSlSqk19Ln2WX21jgZsp3lk=
MIME-Version: 1.0
In-Reply-To: <20090827114704.GB8678@osiris.boeblingen.de.ibm.com>
References: <20090827114704.GB8678@osiris.boeblingen.de.ibm.com>
Date: Thu, 27 Aug 2009 14:18:33 +0200
X-Google-Sender-Auth: d0112e4540f6eeef
Message-ID: <10f740e80908270518n2f7598e7p5f3d6c05bf2d0be0@mail.gmail.com>
Subject: Re: [PATCH] m68k: fix kunmap usage in pte_alloc_one
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 13:47, Heiko Carstens<heiko.carstens@de.ibm.com> wrote:
> Subject: [PATCH] m68k: avoid pgprot_noncached redefinition
>
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Compiling m68k with defconfig gives a lot of these warnings:
>
> In file included from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgalloc.h:13,
>                 from arch/m68k/kernel/dma.c:15:
> arch/m68k/include/asm/motorola_pgalloc.h: In function 'pte_alloc_one':
> arch/m68k/include/asm/motorola_pgalloc.h:44: warning: passing argument 1 of 'kunmap' from incompatible pointer type
>
> kunmap wants a page not a pte.

Thanks, but Linus has just pulled the fix last night.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
