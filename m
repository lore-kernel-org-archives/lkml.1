Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0BLNNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:13:15 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46123 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab0BLNNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PJ0pqEODA8UpjlZLAHPhlMX4I2PMBkkDKlvtPBmyIVwsALC6VV8IwVEql1ArXS0QKy
         XCpZmj1Ks68gXNRUqay/f1+O24FW8gx/5u3DBcXamVIGu3DowIMh1f3VeGNy1IJcmgMY
         pZqKOJbozKSmlSq6KhiAHqJO4GVXN0LYBRuwU=
MIME-Version: 1.0
In-Reply-To: <A8919B3D-43EF-4EA5-8334-F1B52AE97E5A@lvk.cs.msu.su>
References: <cover.1265094517.git.bgat@billgatliff.com>
	 <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com>
	 <20100211200702.GB1487@ucw.cz> <4B746A02.9060306@billgatliff.com>
	 <20100211205801.GA29159@elf.ucw.cz>
	 <A8919B3D-43EF-4EA5-8334-F1B52AE97E5A@lvk.cs.msu.su>
Date: Fri, 12 Feb 2010 14:13:11 +0100
X-Google-Sender-Auth: b65730e5db84b671
Message-ID: <10f740e81002120513y457de2afqa155441941261f7a@mail.gmail.com>
Subject: Re: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution 
	timer and a GPIO pin
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Stanislav O. Bezzubtsev" <stas@lvk.cs.msu.su>
Cc: Pavel Machek <pavel@ucw.cz>, Bill Gatliff <bgat@billgatliff.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/12 Stanislav O. Bezzubtsev <stas@lvk.cs.msu.su>:
> The second strange thing is "unsigned long <name>:1". I'm not sure but as far as I can remember the right way to define several-bits field is "int <name>:1". But I might be mistaken.

A bitfield of size 1 should not be signed, as there's no space for a sign bit.
Usually, you want all bitfields to be unsigned anyway.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
