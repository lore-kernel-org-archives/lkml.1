Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZILHZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZILHZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZILHZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:25:04 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:52780 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZILHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dPsyZBW1M9VrxYFBIvfOfAIi7HhrH3NF4BmgN83I2nsPAwyuNv7K5I9H6ojtpz8Znd
         bd94W/rU/g3dhne4C+5YxVBKNG6mMD0H+4kwfUtd+ponXU7yRPrukwlzHzpHI7zASR7l
         5zD2PMizVXGfXw8ss48CiSbUnib0veia/55G4=
MIME-Version: 1.0
In-Reply-To: <1252734272.31016.94.camel@calx>
References: <200909120103.41128.mboton@gmail.com>
	 <1252734272.31016.94.camel@calx>
Date: Sat, 12 Sep 2009 09:25:05 +0200
X-Google-Sender-Auth: 9710e7cf25afeb59
Message-ID: <10f740e80909120025v7ac5358ew48ae52d9cee5f078@mail.gmail.com>
Subject: Re: [PATCH] logo: random logo selection option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Miguel Boton <waninkoko@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 07:44, Matt Mackall<mpm@selenic.com> wrote:
> On Sat, 2009-09-12 at 01:03 +0200, Miguel Boton wrote:
>> If we select more than one logo in the kernel configuration, only the 'latest' one gets
>> displayed. Because of this the other logos do not ever have a chance to be displayed.
>>
>> This patch adds a selectable option to display a random logo during the bootup process.
>> This way the kernel will be able to display any available logo, making the bootup process
>> a little different every time ;)
>
> [I foolishly read every LKML message with 'random' in the title..]
>
> Bonus points if you add printing a fortune from a compiled-in fortune
> database? Let's not do this, please. Our goal is instead to boot so fast

Hey, we already have a compiled-in fortune database to choose from
(unless CONFIG_PRINTK is disabled)?

> that such things aren't visible.

100% agreed.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
