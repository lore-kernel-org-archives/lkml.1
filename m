Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZIKVpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZIKVpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZIKVpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:45:00 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46856 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZIKVo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cnfjkjuQloXM9EryeW8CHzWhJ04qztxXU+7RngVwpC2hRNt1yFEYr8jSJJU68aGaEM
         P7pMYtICJxbxEU7qDB8P8T4whR3tRJZjKudpRy3UizGcQrJSBCM33Hnkc3fnuwN2edBC
         QEyiUyQHcIlPPEXDOxeIq7eyM/ctcSI0nhevQ=
MIME-Version: 1.0
In-Reply-To: <20090911213204.GC25544@elf.ucw.cz>
References: <20090903232317.GA6760@lst.de>
	 <c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com>
	 <87iqfx5mss.fsf@devron.myhome.or.jp> <20090907125130.GA1595@ucw.cz>
	 <87ljko5k3v.fsf@devron.myhome.or.jp>
	 <20090910192354.GD23356@elf.ucw.cz>
	 <87bplim1ce.fsf@devron.myhome.or.jp>
	 <20090911200922.GF8137@elf.ucw.cz>
	 <c4e36d110909111414n716a06b1mdd0cd741230595b5@mail.gmail.com>
	 <20090911213204.GC25544@elf.ucw.cz>
Date: Fri, 11 Sep 2009 23:45:01 +0200
Message-ID: <c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/11 Pavel Machek <pavel@ucw.cz>:
>
>> And why suspend of mmc should generate card removal ??
>
> Card is powered down during suspend -> mmc can't guarantee the card is
> same and unchanged -> it makes some sense to simulate
> removal/reinsert.

But how is this going to work when I keep the device mounted and
blockdev is basically destroyed -  what if I'm reading file from card
during suspend ?

>> if I suspend and resume my laptop and I keep the card inside - all
>> those step looks plain wrong.
>
> Unfortunately system can't tell.

Well system could check basic card ids if they match after resume - if
some users wants to crash his card by randomly swapping it during
suspend/resume - I'd have no problem with that....

Zdenek
