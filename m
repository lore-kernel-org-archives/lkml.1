Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980Ab0AaVXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0AaVXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209Ab0AaVXO
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:23:14 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47658 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0AaVXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:23:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RxWMibgS4yAUDhGCxqxX/Rdt8bDox4a1YYsahdc9fJEK0TQLIoxgDglrk+vlOAVnlr
         lpq8rnmRxZUhGvj2Mzv8UhhzvHiFU7TBQy/LAJL9xiZLSevXYpMA9r5fXaXnTKurHlSj
         CzprKG2iwZmxOGX8DsUkIU/ZrcgNIdw4CNm48=
MIME-Version: 1.0
In-Reply-To: <3ed42b473cd234c42a7c7a0f96f69b5cc4c9d752.1264967499.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com> <3ed42b473cd234c42a7c7a0f96f69b5cc4c9d752.1264967499.git.joe@perches.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 31 Jan 2010 22:22:51 +0100
Message-ID: <69e28c911001311322v7f3bdd9v4fd2fe85b2e50d1a@mail.gmail.com>
Subject: Re: [PATCH 06/10] drivers/staging: Fix continuation line formats
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 9:02 PM, Joe Perches <joe@perches.com> wrote:
> String constants that are continued on subsequent lines with \
> are not good.
> Fixed a "is tryied" / tried typo
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/dream/qdsp5/audio_mp3.c            |    3 +--
>  .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    3 +--
>  drivers/staging/rtl8187se/r8180_core.c             |    3 +--
>  drivers/staging/sep/sep_driver.c                   |    3 +--
>  4 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
> index b95574f..7ed6e26 100644
> --- a/drivers/staging/dream/qdsp5/audio_mp3.c
> +++ b/drivers/staging/dream/qdsp5/audio_mp3.c
> @@ -650,8 +650,7 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>                                                       &audio->read_phys,
>                                                       GFP_KERNEL);
>                                if (!audio->read_data) {
> -                                       pr_err("audio_mp3: malloc pcm \
> -                                       buf failed\n");
> +                                       pr_err("audio_mp3: malloc pcm buf failed\n");
>                                        rc = -1;
>                                } else {
>                                        uint8_t index;
> diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
> index f1d6cb4..ad42bcd 100644
> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
> @@ -482,8 +482,7 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
>                (!ieee->enter_sleep_state) ||
>                (!ieee->ps_is_queue_empty)){
>
> -               printk("ERROR. PS mode is tryied to be use but\
> -driver missed a callback\n\n");
> +               printk("ERROR. PS mode tried to be use but driver missed a callback\n\n");

This have more typos... "to be use"?

>
>                return -1;
>        }
> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index e0f13ef..278992a 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -3864,8 +3864,7 @@ static int __init rtl8180_pci_module_init(void)
>                return ret;
>        }
>
> -       printk(KERN_INFO "\nLinux kernel driver for RTL8180 \
> -/ RTL8185 based WLAN cards\n");
> +       printk(KERN_INFO "\nLinux kernel driver for RTL8180 / RTL8185 based WLAN cards\n");

While you are at it, change this to read RTL8187SE, since RTL8180/85
are not supported by this driver.

>        printk(KERN_INFO "Copyright (c) 2004-2005, Andrea Merello\n");
>        DMESG("Initializing module");
>        DMESG("Wireless extensions version %d", WIRELESS_EXT);
> diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
> index e7bc9ec..8793878 100644
> --- a/drivers/staging/sep/sep_driver.c
> +++ b/drivers/staging/sep/sep_driver.c
> @@ -380,8 +380,7 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
>           shared area */
>        if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
>                edbg("SEP Driver mmap requested size is more than allowed\n");
> -               printk(KERN_WARNING "SEP Driver mmap requested size is more \
> -                       than allowed\n");
> +               printk(KERN_WARNING "SEP Driver mmap requested size is more than allowed\n");
>                printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n", vma->vm_end);
>                printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n", vma->vm_start);
>                return -EAGAIN;
> --
> 1.6.6.rc0.57.gad7a
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
