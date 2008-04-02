Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYDBKUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYDBKUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYDBKUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:20:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:3349 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYDBKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BOiMchhob8PgF2mBTUti1JiudODbSyTeeK1csva3ngoqABeDes7xPwXKFargfVHI0DzAItcP6C9DpAX7KYq5WWY9ZwA8JwQhow/TScxaiZ8JajD3kLG9NHRLvDyZIO6c7T/B2agmNYr3P2Iv7pQI7fsHPXiQKzM0PBE25ncM+ac=
Message-ID: <6dc076840804020320n261b69ddo7020992f8ad00ddf@mail.gmail.com>
Date: Wed, 2 Apr 2008 19:20:06 +0900
From: "Takashi Iwai" <takashi.iwai@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: fix comments in sound/core.h (fwd)
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Trivial patch monkey" <trivial@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>, perex@perex.cz
In-Reply-To: <20080401114011.GA10887@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401114011.GA10887@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

I've been on vacation (a sort of honeymoon) until April 11.
So I cannot work on your patches right now.  Sorry for inconvenience.


Takashi

On 4/1/08, Pavel Machek <pavel@ucw.cz> wrote:
> Do we have sound maintainers? Noone replies on trivial patches :-(.
>
>                                                        Pavel
>
> ----- Forwarded message from Pavel Machek <pavel@suse.cz> -----
>
> From: Pavel Machek <pavel@suse.cz>
> To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
>        Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
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
>  * snd_printd - debug printk
>  * @fmt: format string
>  *
> - * Compiled only when Works like snd_printk() for debugging purpose.
> + * Works like snd_printk() for debugging purposes.
>  * Ignored when CONFIG_SND_DEBUG is not set.
>  */
>  #define snd_printd(fmt, args...) \
> @@ -417,7 +417,7 @@ #ifdef CONFIG_SND_DEBUG_DETECT
>  * snd_printdd - debug printk
>  * @format: format string
>  *
> - * Compiled only when Works like snd_printk() for debugging purpose.
> + * Works like snd_printk() for debugging purposes.
>  * Ignored when CONFIG_SND_DEBUG_DETECT is not set.
>  */
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
>
