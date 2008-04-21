Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbYDUVly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbYDUVly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760295AbYDUVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:36:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:32931 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760280AbYDUVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=tVZyzw8mkWsQvJ+NgF5LXXVteoEdQJHPlji+W1G91T/ptA33g9RDjEDBhimxKBPVtnSFV1t+ark5XYj7b+p5zZzc2mQc44JQDoC/wGYdT57pmdD6ceETO1c3GWyABdXvFg9yqB6Yg0Ud9m7oQsbET3qmzn6efGbxK3o3WCW6CL4=
Date: Mon, 21 Apr 2008 23:36:56 +0200 (CEST)
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@osdl.org>, Trivial patch monkey <trivial@kernel.org>,
       tiwai@suse.de, kernel list <linux-kernel@vger.kernel.org>,
       perex@perex.cz
Subject: Re: fix comments in sound/core.h (fwd)
In-Reply-To: <20080401114011.GA10887@elf.ucw.cz>
Message-ID: <alpine.LNX.1.00.0804212333340.1777@dragon.funnycrock.com>
References: <20080401114011.GA10887@elf.ucw.cz>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Pavel Machek wrote:

> Do we have sound maintainers? Noone replies on trivial patches :-(.
> 

I handle trivial patches (well, at least those send to 
trivial@kernel.org).
I don't check that mailbox daily though - for a few reasons;

1. I prefer to wait a while to see if patches get merged elsewhere before 
bothering about them for Trivial.

2. I only just took over Trivial fron Adrian and I've still to work out 
how to deal with it properly.

/Jesper Juhl


> 							Pavel
> 
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
