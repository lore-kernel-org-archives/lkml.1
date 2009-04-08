Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZDHHAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZDHHAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDHHAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:00:01 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39411 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZDHG76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ea1+PUUvbnbOOYkPZH6IeUJknUerJfEEKsjXq/rRuBS7q6KORo3PpYZymb2HT0JTWV
         58Q6b5r8YKQzfckRk2eJtrF7L6Xl1OCs+U3Nv0JeZ9KP4C49SlHRw0MUumuItVDNCtt1
         wzx6urf5dlzPj8b3i4rHwTPUcyoi99DMMnF0A=
MIME-Version: 1.0
In-Reply-To: <1239167872-8179-3-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <1239167872-8179-3-git-send-email-joe@perches.com>
Date: Wed, 8 Apr 2009 08:59:54 +0200
X-Google-Sender-Auth: 5dda04353817b626
Message-ID: <10f740e80904072359n49ab104fjc545fa9f4617d5ad@mail.gmail.com>
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 07:17, Joe Perches <joe@perches.com> wrote:
> Better description of file pattern tag "F:"
> Add file exclusion tag "X:"
> Add patterns to sections
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3b2159..a8034dd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -55,422 +55,522 @@ trivial patch so apply some common sense.

>  M68K ARCHITECTURE
>  P:     Geert Uytterhoeven
>  M:     geert@linux-m68k.org
>  P:     Roman Zippel
>  M:     zippel@linux-m68k.org
>  L:     linux-m68k@lists.linux-m68k.org
>  W:     http://www.linux-m68k.org/
>  T:     git git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
>  S:     Maintained
> +F:     arch/m68k/

You can add drivers/zorro/ (Amiga Zorro bus) there, too

>  M68K ON APPLE MACINTOSH
>  P:     Joshua Thompson
>  M:     funaho@jurai.org
>  W:     http://www.mac.linux-m68k.org/
>  L:     linux-m68k@lists.linux-m68k.org
>  S:     Maintained

That would be arch/m68k/mac/

>  M68K ON HP9000/300
>  P:     Philip Blundell
>  M:     philb@gnu.org
>  W:     http://www.tazenda.demon.co.uk/phil/linux-hp
>  S:     Maintained
> +F:     arch/m68k/hp300/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
