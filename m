Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbZEMIz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbZEMIz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbZEMIzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:55:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35104 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbZEMIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:55:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c51H3pw+qVd8FWhvBVZFRBLlcWVM8upgPdKRCRw/Kp9LcI54E/zn2ExQZxldBLEac6
         bTAjbJCxllLTyQNdcrR8eTAw0JFquHWjaG3FLkPn1pN9D17KQld3XE2QI+Ms0MkI2yRi
         cCYNpr5K4mNQh4000QNTvlS/DaQ735RMvT1FE=
MIME-Version: 1.0
In-Reply-To: <20090513095127.308b00e7@lxorguk.ukuu.org.uk>
References: <20090511222702.352192505@arndb.de>
	 <200905112238.55404.arnd@arndb.de>
	 <20090512090602.65722342@lxorguk.ukuu.org.uk>
	 <200905121123.21436.arnd@arndb.de>
	 <20090513033027.GA13193@cynthia.pants.nu>
	 <alpine.DEB.1.00.0905130610240.18305@zirkon.biophys.uni-duesseldorf.de>
	 <20090513043409.GA13577@cynthia.pants.nu>
	 <20090513095127.308b00e7@lxorguk.ukuu.org.uk>
Date: Wed, 13 May 2009 10:55:09 +0200
X-Google-Sender-Auth: d59f689e76a99a53
Message-ID: <10f740e80905130155pd24c4e3n538be3110ac34b54@mail.gmail.com>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Brad Boyer <flar@allandria.com>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:51, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > If it doesn't interfere with plain PIO mode, fine.
>>
>> I agree. There definitely needs to still be support for IDE ports that
>> don't have DMA capability.
>
> There is - it's just if the platform doesn't implement the dma_* APIs you
> get a problem.

Note that there are other things missing on m68k and m32r, that's why
Al added the

| depends on !(M32R || M68K) || BROKEN

commit 9317fd4c60962d3a9423b5f9bb5d1b10cf8a0699
Author: Al Viro <viro@ftp.linux.org.uk>
Date:   Sun Sep 24 23:40:00 2006 +0100

    [PATCH] libata won't build on m68k and m32r

    no ioread*(), for one thing

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
