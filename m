Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYFTSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYFTSJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbYFTSJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:09:15 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:57334 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYFTSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=XmZLEEACYOUfCGwI1WrejwEV6ndaP/qhLLkOkmt1B98DU1M+wl5p8jsFgQnMsR4vGF
         vW6s1xAJqBjJLgOF4nX9b+r3Eax+Du2FaTHcIBgX8/QlbCGN81S20ObMk/5KugBR07Yb
         GsGTtjNwqXXthum7CcidKJXa7jZCZ2zfmmYr4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Philippe De Muyter <phdm@macqel.be>
Subject: Re: [PATCH] pcmcia ide kingston compactflash's have a new manufacturer id
Date: Fri, 20 Jun 2008 19:23:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080619150537.GA19698@frolo.macqel>
In-Reply-To: <20080619150537.GA19698@frolo.macqel>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806201923.45932.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 19 June 2008, Philippe De Muyter wrote:
> Hi everybody,
> 
> Up to now, Kingston compactflash cards (ab)used the Toshiba Manufacturer's ID,
> In their new CF cards, they use a new one.  Let's the ide subsystem
> recognize CF cards with the new id.
> 
> Signed-off-by: Christophe Niclaes <cniclaes@develtech.com>
> Acked-by: Philippe De Muyter <phdm@macqel.be>

applied, thanks

> diff -r 60ebd5153c48 drivers/ide/legacy/ide-cs.c
> --- a/drivers/ide/legacy/ide-cs.c	Wed Jun 18 22:12:50 2008 -0700
> +++ b/drivers/ide/legacy/ide-cs.c	Thu Jun 19 16:35:29 2008 +0200
> @@ -410,6 +410,7 @@ static struct pcmcia_device_id ide_ids[]
>  	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
>  	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
>  	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
> +	PCMCIA_DEVICE_MANF_CARD(0x004f, 0x0000),	/* Kingston */
>  	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
>  	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
>  	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
