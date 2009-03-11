Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZCKOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZCKOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZCKOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:38:15 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:46434 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZCKOiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A0Xwcqxxa1SZkb698SBQkGALOp+8JIpdStpeXZj7/Q/9U9qpzHItKGdJEAPTHc80+f
         O5uEILAHbKMmgZgXp/BwewA6Ewc7+vgXZU+T0kmEJ9+buRcDecA/PLxOV8TeVqCBDpni
         nzAlgmVV1KiIZo9xP5D3/nWNvFYUO/2nL/C/A=
MIME-Version: 1.0
In-Reply-To: <200903111534.34340.wolfgang.mues@auerswald.de>
References: <87a5b0800903110656x7000e0c8q23ceae7e87483bf7@mail.gmail.com>
	 <200903111534.34340.wolfgang.mues@auerswald.de>
Date: Wed, 11 Mar 2009 14:38:09 +0000
Message-ID: <87a5b0800903110738h508aae87y7fc462d30cc89c7f@mail.gmail.com>
Subject: Re: [PATCH 7/7] mmc_spi: support for non-byte-aligned cards
From: Will Newton <will.newton@gmail.com>
To: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 2:34 PM, Wolfgang Mües
<wolfgang.mues@auerswald.de> wrote:
> Will,
>
> Am Mittwoch, 11. März 2009 schrieb Will Newton:
>> <wolfgang.mues@auerswald.de> wrote:
>> > From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>> >
>> > o A very large subset of SD cards in the market send their
>> >  responses and data non-byte-aligned. So add logic to the
>> >  mmc spi driver to handle this mess.
>>
>> Are you sure about this?
>
> Yes.
>
>> Do you have any further references for this
>> or examples of cards that exhibit this problem?
>
> Kingston. The 1 GByte SD card, and a 128 MByte microSD card. I have got some
> reports from other mmc spi users with the same problem.

Are they using the same host controller? Have you tried these cards
with a different host controller?

Are you clocking them particularly slow or fast?

> The SD protocoll ist NOT byte-aligned. Messages are starting with a
> leading "0" bit. I think some chip vendors have adapted the SPI mode from SD
> mode and forgotten to do propper byte alignment.
>
>> Are you sure your SPI host controller is operating correctly?
>
> Yes. My logic probe gives the same results as my spi host controller.
> For some cards, you can see the bit offset is getting larger if the
> controller on the SD card is getting more and more busy...

A logic probe may not display any signal integrity issues you might have.
