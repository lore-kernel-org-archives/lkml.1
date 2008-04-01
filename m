Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYDAND2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYDAND2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYDANDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:03:19 -0400
Received: from mail1.perex.cz ([212.20.107.53]:38549 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYDANDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:03:18 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 09:03:18 EDT
Date: Tue, 1 Apr 2008 14:34:08 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@osdl.org>, Trivial patch monkey <trivial@kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fix comments in sound/core.h (fwd)
In-Reply-To: <20080401114011.GA10887@elf.ucw.cz>
Message-ID: <Pine.LNX.4.61.0804011433300.21832@tm8103.perex-int.cz>
References: <20080401114011.GA10887@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Pavel Machek wrote:

> Do we have sound maintainers? Noone replies on trivial patches :-(.

Applied to ALSA repository. Thanks.

					Jaroslav

> ----- Forwarded message from Pavel Machek <pavel@suse.cz> -----
> 
> From: Pavel Machek <pavel@suse.cz>
> To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
> 	Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
> Subject: fix comments in sound/core.h
> X-Warning: Reading this can be dangerous to your mental health.
> 
> 
> Two sentences seem to be spliced into one in comment, fix that and fix
> english. Also fix codingstyle.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz> 
> 
> diff --git a/include/sound/core.h b/include/sound/core.h
> index 4fc0235..452000d 100644
> --- a/include/sound/core.h
> +++ b/include/sound/core.h
> @@ -310,7 +310,7 @@ int snd_card_file_add(struct snd_card *c
>  int snd_card_file_remove(struct snd_card *card, struct file *file);
>  
>  #ifndef snd_card_set_dev
> -#define snd_card_set_dev(card,devptr) ((card)->dev = (devptr))
> +#define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
>  #endif
>  
>  /* device.c */
> @@ -373,7 +373,7 @@ #ifdef CONFIG_SND_VERBOSE_PRINTK
>   * snd_printd - debug printk
>   * @fmt: format string
>   *
> - * Compiled only when Works like snd_printk() for debugging purpose.
> + * Works like snd_printk() for debugging purposes.
>   * Ignored when CONFIG_SND_DEBUG is not set.
>   */
>  #define snd_printd(fmt, args...) \
> @@ -417,7 +417,7 @@ #ifdef CONFIG_SND_DEBUG_DETECT
>   * snd_printdd - debug printk
>   * @format: format string
>   *
> - * Compiled only when Works like snd_printk() for debugging purpose.
> + * Works like snd_printk() for debugging purposes.
>   * Ignored when CONFIG_SND_DEBUG_DETECT is not set.
>   */
>  #define snd_printdd(format, args...) snd_printk(format, ##args)
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
> 
> ----- End forwarded message -----
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

