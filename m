Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbZEaT2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbZEaT2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 15:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZEaT14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 15:27:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:39049 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZEaT1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 15:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XWWhT2QIJ76g7A6mS0zbRB7UZQe9lLGYe7yUBiPHtihsDtThUWlKVXoD+UjGAjSI2K
         zgY8qIRAUS6vVuHOI8k2hmuly5sawZfa1fp5CLeDAkHFT0dEhShorGhAP40FbtDgxg8g
         r7xNiUxqy/B5sJi9+C0MRYOHioPePUOSbGkV4=
MIME-Version: 1.0
In-Reply-To: <20090531080434.GA16463@jasper.tkos.co.il>
References: <1243338914-7811-1-git-send-email-baruch@tkos.co.il>
	 <63386a3d0905271416u4b2cee48k40c12e91e1796f83@mail.gmail.com>
	 <20090531080434.GA16463@jasper.tkos.co.il>
Date: Sun, 31 May 2009 21:27:56 +0200
Message-ID: <63386a3d0905311227v5bb5c278r306e8ae429e77691@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH] spi: driver for the Synopsys 
	DesignWare SPI controller
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: gregkh@suse.de, Baruch Siach <baruch@tkos.co.il>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/31 Baruch Siach <baruch@tkos.co.il>:

>> > +       r = platform_get_resource(dev, IORESOURCE_MEM, 0);
>> > +       if (r == NULL) {
>> > +               ret = -ENODEV;
>>
>> -ENOENT
>
> A quick search in the drivers tree showed no -ENOENT in this situation. Of the
> 10 first results of grep -ENODEV is the most popular as follows:
[The other: 3x -EINVAL one -ENXIO]

Wowsers! And I felt -ENOENT was so intuitive, well if I'm going against
common practice, no good. So let's ask the maintainer of the platform bus
what shall be returned in this situation:

Greg (or some other wise person from linux-kernel) what would you return if
platform_get_resource() returns NULL for an expected resource?

Linus Walleij
