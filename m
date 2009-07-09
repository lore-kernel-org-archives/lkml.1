Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZGIVRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZGIVRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZGIVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:17:44 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38971 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZGIVRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BDEn/q1OdrjZaUMKgHchT0vpRLvIRxPtfBZhYZBwuJthBQV+ptP027/8zmouDw5ZFB
         Orc/Pnw2gEAtqQcNSrsbDtMmzq4j2N1X8sY7MB+xFProv3ScJ1G4FgxbLlAQSz+cJB8O
         /8awjSJ+6sgnLyHWMDDWrZyUUlrXRxSWDw9Oc=
MIME-Version: 1.0
In-Reply-To: <1247074967.4382.115.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247067147.4382.80.camel@ht.satnam>
	 <63386a3d0907081028s4a36fccen9cea9a316e2ef4c6@mail.gmail.com>
	 <1247074967.4382.115.camel@ht.satnam>
Date: Thu, 9 Jul 2009 23:17:41 +0200
Message-ID: <63386a3d0907091417u2014ad2ax645015e4cbbaa50c@mail.gmail.com>
Subject: Re: [PATCH 29/44] includecheck fix: drivers/spi, amba-pl022.c
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> On Wed, 2009-07-08 at 19:28 +0200, Linus Walleij wrote:
>> 2009/7/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:
>>
>> > fix the following 'make includecheck' warnings:
>> >
>> >  drivers/spi/amba-pl022.c: linux/delay.h is included more than once.
>> >  drivers/spi/amba-pl022.c: linux/errno.h is included more than once.
>>
>> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
>>
>> David are you merging this?
>
> This is a big patchset, So better me or Sam will send this to Linus
> after collecting some more ACKs.

Not me I hope (damned I knew this would happen sooner or later).
return -ELINWAL

Having this name is very convenient, people review my drivers like
crazy.

Linus Walleij
