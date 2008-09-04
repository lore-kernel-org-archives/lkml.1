Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYIDJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYIDJu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYIDJuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:50:12 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:53802 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbYIDJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:50:10 -0400
X-Greylist: delayed 1008 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 05:50:10 EDT
Date: Thu, 04 Sep 2008 11:49:21 +0200 (CEST)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 5/8] m68k: Remove unused atari_kbd_translate()
In-reply-to: <20080903071742.326285837@mail.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.1.00.0809041148100.12258@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <20080903071542.615137611@mail.of.borg>
 <20080903071742.326285837@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

acked as requested.

> If CONFIG_VT=n, I get:
>
> | arch/m68k/atari/built-in.o: In function `atari_kbd_translate':
> | arch/m68k/atari/atakeyb.c:640: undefined reference to `shift_state'
>
> Just remove atari_kbd_translate(), as it's unused.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Michael Schmity <schmitz@debian.org>

> ---
> arch/m68k/atari/atakeyb.c |   12 ------------
> 1 file changed, 12 deletions(-)
>
> --- a/arch/m68k/atari/atakeyb.c
> +++ b/arch/m68k/atari/atakeyb.c
> @@ -635,15 +635,3 @@ int atari_keyb_init(void)
> 	return 0;
> }
> EXPORT_SYMBOL_GPL(atari_keyb_init);
> -
> -int atari_kbd_translate(unsigned char keycode, unsigned char *keycodep, char raw_mode)
> -{
> -#ifdef CONFIG_MAGIC_SYSRQ
> -	/* ALT+HELP pressed? */
> -	if ((keycode == 98) && ((shift_state & 0xff) == 8))
> -		*keycodep = 0xff;
> -	else
> -#endif
> -		*keycodep = keycode;
> -	return 1;
> -}
>
> --
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
