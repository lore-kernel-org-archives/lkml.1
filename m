Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYGABR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYGABR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYGABRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:17:21 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:23098 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbYGABRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:17:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [Linux-fbdev-devel] [PATCH 1/13] viafb: viafb.modes, viafb.txt
Date: Tue, 1 Jul 2008 09:17:16 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7CFB@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080630124628.194b782f@neptune.home>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 1/13] viafb: viafb.modes, viafb.txt
Thread-Index: Acjan9EmPgh1KEWNRWyZGwv3EoebagAeBbtA
From: <JosephChan@via.com.tw>
To: <bonbons@linux-vserver.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 01 Jul 2008 01:17:19.0202 (UTC) FILETIME=[34D34C20:01C8DB18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m611HWfq006984

Bruno,

Thanks for checking, I also find that.
I will inform our engineers to re-fine it. 

BRs,
Joseph Chan 
-----Original Message-----
From: Bruno PrÃ©mont [mailto:bonbons@linux-vserver.org] 
Sent: Monday, June 30, 2008 6:46 PM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/13] viafb: viafb.modes, viafb.txt

On Mon, 30 June 2008 <JosephChan@via.com.tw> wrote:
> diff -Nur a/Documentation/fb/viafb.txt b/Documentation/fb/viafb.txt
> --- a/Documentation/fb/viafb.txt	1970-01-01 08:00:00.000000000
> +0800 +++ b/Documentation/fb/viafb.txt	2009-01-02 16:28:20.000000000 +0800
> [...]
> +[Using the viafb module]
> +-- -- --------------------
> +    Start viafb with default settings:
> +        #modprobe viafb
> +
> +    Start viafb with with user options:
> +        #modprobe viafb viafb_mode=800x600 via_fb_bpp=16 viafb_refresh=60 
> +                  viafb_active_dev=CRT+DVI viafb_dvi_port=DVP1
> +                  viafb_mode1=1024x768 via_fb_bpp=16 viafb_refresh1=60
> +                  viafb_SAMM_ON=1
> +
> +    viafb_mode:
> +        640x480 (default)
> +        720x480 
> +        800x600 
> +        1024x768
> +        ......
> +
> +    via_fb_bpp:
> +        8, 16, 32 (default:32)
> +
> +    viafb_refresh:
> +        60, 75, 85, 100, 120 (default:60)
> +
> [...]
Is there a specific reason why some module options start with via_fb_ and others with viafb_?


> +[Building viafb as a built - in driver on Linux kernel 2.6.xx]
> +--------------------------------------------------------------
> +    Step 1: Get kernel source and put them under /usr/src/linux 
> +    Step 2: Copy FBDev to proper location.
> +            # cp -a FBDev /usr/src/linux/drivers/video/via
> +    Step 3: Modify Makefile and Kconfig under /usr/src/linux/drivers/video:
> +        add line to Makefile
> +	        "obj-$(CONFIG_FB_VIA)              += via/"
> +
> +        add below lines to Kconfig
> +           config FB_VIA
> +               tristate "VIA UniChrome (Pro) and Chrome9 display support"
> +               depends on FB && PCI 
> +               select FB_CFB_FILLRECT 
> +               select FB_CFB_COPYAREA
> +               select FB_CFB_IMAGEBLIT 
> +               select FB_SOFT_CURSOR
> + 
> +           help
> +               This is the frame buffer device driver for Graphics
> +               chips of VIA UniChrome Family(CLE266, PM800 / CN400 / CN300,
> +                                             P4M800CE / P4M800Pro / CN700,
> +                                             VN800 / CX700 / VX700, K8M890,
> +                                             P4M890 / CN896 / P4M900, VX800)
> +               Say Y if you have a VIA UniChrome graphics board. To compile
> +               this driver as a module, choose M here: the module will be
> +               called viafb.
This section can be dropped, the patch series aiming to merge viafb into mainline tree. (the patch series does this already)

-
Bruno

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
