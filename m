Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbXKEIav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbXKEIav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXKEIao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:30:44 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57241 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752892AbXKEIan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:30:43 -0500
Date: Mon, 5 Nov 2007 09:30:37 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] drivers/video/ps3fb: fix memset size error
In-Reply-To: <472E7FBC.7020906@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.62.0711050930170.1532@pademelon.sonytel.be>
References: <472E7FBC.7020906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-667897339-1194251437=:1532"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-667897339-1194251437=:1532
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 5 Nov 2007, Li Zefan wrote:
> The size passing to memset is wrong.
> 
> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> ---
>  drivers/video/ps3fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
> index b3463dd..75836aa 100644
> --- a/drivers/video/ps3fb.c
> +++ b/drivers/video/ps3fb.c
> @@ -727,7 +727,7 @@ static int ps3fb_blank(int blank, struct fb_info *info)
>  
>  static int ps3fb_get_vblank(struct fb_vblank *vblank)
>  {
> -	memset(vblank, 0, sizeof(&vblank));
> +	memset(vblank, 0, sizeof(*vblank));
>  	vblank->flags = FB_VBLANK_HAVE_VSYNC;
>  	return 0;
>  }

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-667897339-1194251437=:1532--
