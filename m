Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbXFFNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbXFFNJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXFFNJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:09:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:1616 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbXFFNJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UgPVTF1/nApNFOIqTXsLJv83YXJZOOfkjZ4FPAlA2KDNB+Ytw68Z9aDi6FmJzDsNsOB2CFjyQMgt6Pt8mC09eoLdn9BNHJiSQYV2ACXjiQJW+vjsRyeqCyKVSPyczAREQkYT4kttgTMDUpMMeuivQL6Pc5QyOsdmJom81Aulla4=
Message-ID: <4666B21F.60508@gmail.com>
Date: Wed, 06 Jun 2007 15:09:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] Minor cleanups in tty_ioctl.c
References: <20070523172739.1d3a918c@the-village.bc.nu>	 <1180012135.8303.89.camel@shinybook.infradead.org>	 <20070524144109.7bd0f4d0@the-village.bc.nu>	 <1180014338.8303.95.camel@shinybook.infradead.org>	 <20070524160559.54c2c639@the-village.bc.nu> <1181133269.4096.34.camel@pmac.infradead.org>
In-Reply-To: <1181133269.4096.34.camel@pmac.infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse napsal(a):
> Cosmetic stuff which annoyed me while I was poking at it...
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> 
> diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
> index fd471cb..79e9c17 100644
> --- a/drivers/char/tty_ioctl.c
> +++ b/drivers/char/tty_ioctl.c
> @@ -276,8 +276,8 @@ void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed
>  				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
>  			ifound = i;
>  		}
> -	}
> -	while(++i < n_baud_table);
> +	} while(++i < n_baud_table);
> +
>  	if (ofound == -1)
>  		termios->c_cflag |= BOTHER;
>  	/* Set exact input bits only if the input and output differ or the

I think, you use old version of tty_ioctl.c :)

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/broken-out/char-tty_ioctl-little-whitespace-cleanup.patch

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
