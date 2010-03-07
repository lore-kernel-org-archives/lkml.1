Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0CGMlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:41:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45251 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0CGMlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w21FurPDotSI+qV5DrWt6eP5mW2qwjvzC0kvw3Pib6XVcjTaZnFPZlj9xgE9iJVMVQ
         o+Iep5SF6wt4tmzvLV4g29bvSjkxUNWa8jKr54m9PTthgz5DdrFhO7yYcifVNvbEMqA5
         rOWuN7H2jlCgiXHd66vpI7pHAkkkHcUNgNpxk=
MIME-Version: 1.0
In-Reply-To: <1265478443-31072-4-git-send-email-elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
	 <1265478443-31072-4-git-send-email-elendil@planet.nl>
Date: Sun, 7 Mar 2010 13:41:15 +0100
X-Google-Sender-Auth: 9a3b23ec55e686b7
Message-ID: <10f740e81003070441w64ba9c56ve17c343d6310ead9@mail.gmail.com>
Subject: Re: [PATCH 04/16] m68k: remove trailing space in messages
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 6, 2010 at 18:47, Frans Pop <elendil@planet.nl> wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: Roman Zippel <zippel@linux-m68k.org>

Thx, applied.

> ---
>  arch/m68k/kernel/traps.c |    2 +-
>  arch/m68k/mac/config.c   |   10 +++++-----
>  arch/m68k/q40/config.c   |    2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
> index aacd6d1..e533f32 100644
> --- a/arch/m68k/kernel/traps.c
> +++ b/arch/m68k/kernel/traps.c
> @@ -455,7 +455,7 @@ static inline void access_error040(struct frame *fp)
>
>                if (do_page_fault(&fp->ptregs, addr, errorcode)) {
>  #ifdef DEBUG
> -                       printk("do_page_fault() !=0 \n");
> +                       printk("do_page_fault() !=0\n");
>  #endif
>                        if (user_mode(&fp->ptregs)){
>                                /* delay writebacks after signal delivery */
> diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
> index 0356da9..1c16b1b 100644
> --- a/arch/m68k/mac/config.c
> +++ b/arch/m68k/mac/config.c
> @@ -148,7 +148,7 @@ static void mac_cache_card_flush(int writeback)
>  void __init config_mac(void)
>  {
>        if (!MACH_IS_MAC)
> -               printk(KERN_ERR "ERROR: no Mac, but config_mac() called!! \n");
> +               printk(KERN_ERR "ERROR: no Mac, but config_mac() called!!\n");
>
>        mach_sched_init = mac_sched_init;
>        mach_init_IRQ = mac_init_IRQ;
> @@ -867,7 +867,7 @@ static void __init mac_identify(void)
>         */
>        iop_preinit();
>
> -       printk(KERN_INFO "Detected Macintosh model: %d \n", model);
> +       printk(KERN_INFO "Detected Macintosh model: %d\n", model);
>
>        /*
>         * Report booter data:
> @@ -878,12 +878,12 @@ static void __init mac_identify(void)
>                mac_bi_data.videoaddr, mac_bi_data.videorow,
>                mac_bi_data.videodepth, mac_bi_data.dimensions & 0xFFFF,
>                mac_bi_data.dimensions >> 16);
> -       printk(KERN_DEBUG " Videological 0x%lx phys. 0x%lx, SCC at 0x%lx \n",
> +       printk(KERN_DEBUG " Videological 0x%lx phys. 0x%lx, SCC at 0x%lx\n",
>                mac_bi_data.videological, mac_orig_videoaddr,
>                mac_bi_data.sccbase);
> -       printk(KERN_DEBUG " Boottime: 0x%lx GMTBias: 0x%lx \n",
> +       printk(KERN_DEBUG " Boottime: 0x%lx GMTBias: 0x%lx\n",
>                mac_bi_data.boottime, mac_bi_data.gmtbias);
> -       printk(KERN_DEBUG " Machine ID: %ld CPUid: 0x%lx memory size: 0x%lx \n",
> +       printk(KERN_DEBUG " Machine ID: %ld CPUid: 0x%lx memory size: 0x%lx\n",
>                mac_bi_data.id, mac_bi_data.cpuid, mac_bi_data.memsize);
>
>        iop_init();
> diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
> index 31ab3f0..ad10fec 100644
> --- a/arch/m68k/q40/config.c
> +++ b/arch/m68k/q40/config.c
> @@ -126,7 +126,7 @@ static void q40_reset(void)
>  {
>         halted = 1;
>         printk("\n\n*******************************************\n"
> -               "Called q40_reset : press the RESET button!! \n"
> +               "Called q40_reset : press the RESET button!!\n"
>                "*******************************************\n");
>        Q40_LED_ON();
>        while (1)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
