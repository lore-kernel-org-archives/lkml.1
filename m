Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0BWGNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:13:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:31582 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0BWGNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B7ENB96h4W01zwZ7X9IZrJeAHAzicwoC9pZBrRlNFZgQ1ndqbie6ebsPKAW1hBHz6A
         vVt3rKxsg80WU1qnWAo1ZAy/j25BSXPGNKf6+L4N8RhE6oySZpgLycsuVVpVLZ4rIRZT
         K8H3Fq1lpcgtkHQ/1RAVHS9jRS2gqCXi00ZoE=
MIME-Version: 1.0
In-Reply-To: <4B7F2EC7.6000305@gmail.com>
References: <4B7F2EC7.6000305@gmail.com>
Date: Tue, 23 Feb 2010 07:13:33 +0100
X-Google-Sender-Auth: 0c8156b67e7e58a5
Message-ID: <10f740e81002222213n3ef9608frd81422cd9a74c04@mail.gmail.com>
Subject: Re: [PATCH] m68k,m68knommu: missing asterisk?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Peter 'p2' De Schrijver" <p2@debian.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 01:37, Roel Kluin <roel.kluin@gmail.com> wrote:
> An asterisk was missing.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Correct?

No, see arch/m68k/apollo/config.c:dn_dummy_hwclk().
Andrew: please dequeue.

>  arch/m68k/include/asm/apollohw.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/include/asm/apollohw.h b/arch/m68k/include/asm/apollohw.h
> index a1373b9..87e0cc4 100644
> --- a/arch/m68k/include/asm/apollohw.h
> +++ b/arch/m68k/include/asm/apollohw.h
> @@ -94,7 +94,7 @@ extern u_long timer_physaddr;
>
>  #define sio01 ((*(volatile struct SCN2681 *)(IO_BASE + sio01_physaddr)))
>  #define sio23 ((*(volatile struct SCN2681 *)(IO_BASE + sio23_physaddr)))
> -#define rtc (((volatile struct mc146818 *)(IO_BASE + rtc_physaddr)))
> +#define rtc ((*(volatile struct mc146818 *)(IO_BASE + rtc_physaddr)))
>  #define cpuctrl (*(volatile unsigned int *)(IO_BASE + cpuctrl_physaddr))
>  #define pica (IO_BASE + pica_physaddr)
>  #define picb (IO_BASE + picb_physaddr)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
