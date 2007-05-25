Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXEYH0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXEYH0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXEYHZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:25:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5591 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXEYHZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=llKIJEWH9/XWTyqjTeEmL/wKPb96bcx4MkEEzf1TLygEv+NC8yR5z5dGIpD2NIXAiVTB8WWZSl3HOWf4c6E8p36X2ebNNEN+kkRzIwh0cUGzT9ZjoCcpjd6i52mP5vutVmCqUC9tH9Q5YCpOpz2mTmH0fJr9YC7xOkxzIlYFLuk=
Message-ID: <46568F7F.1040100@gmail.com>
Date: Fri, 25 May 2007 09:25:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Yoann Padioleau <padator@wanadoo.fr>
CC: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] old declaration ritchie style fix
References: <87y7jemb1u.fsf@wanadoo.fr>
In-Reply-To: <87y7jemb1u.fsf@wanadoo.fr>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoann Padioleau napsal(a):
> Use consistent function declaration style.
> 
> Note that this file is not compiled by make allyesconfig
> and its configuration option appears nowhere. Perhaps
> it would be better to remove the file.

I don't know where were you looking, but it is referenced in both Makefile and
Kconfig in drivers/net/ and depends on ATARI && ATARI_ACSI && BROKEN. I suppose
you don't have atari.

> ---
> 
>  atari_pamsnet.c |   62 +++++++++++++++++++-------------------------------------
>  1 file changed, 22 insertions(+), 40 deletions(-)
> 
> 
> diff --git a/drivers/net/atari_pamsnet.c b/drivers/net/atari_pamsnet.c
> index 5471440..ea5b868 100644
> --- a/drivers/net/atari_pamsnet.c
> +++ b/drivers/net/atari_pamsnet.c
[...]
> @@ -501,9 +483,7 @@ pamsnet_intr(irq, data, fp)
>  /* receivepkt() loads a packet to a given buffer and returns its length */
>  
>  static int
> -receivepkt (target, buffer)
> -	int target;
> -	unsigned char *buffer;
> +receivepkt (int target, unsigned char *buffer)

When you are at it, you can also get rid of bsd return-type-on-its-own-line
style + remove the space before parenthesis.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
