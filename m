Return-Path: <linux-kernel-owner+w=401wt.eu-S935289AbYD1Tfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289AbYD1Tfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbYD1TfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:35:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:40055 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbYD1TfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OYIwYv78eS1Y2h1nr5c0tlnoEhxdzBLsa0O74xADymfBL4tQbK68CxG8p/w+qE66cRbKQA9ZXZ4xi7ZSi/nqWqbxmEO/dUSI2fd1RnftjVeJAm2kA+uyliAUMq5dG9SJ/gDJ7tKDSvdWVcZJ1gKOo2Ixju/1aa9/wmGGCpxo6EY=
Message-ID: <ca2dc2820804281235n533f1daam26a5c064829165dc@mail.gmail.com>
Date: Mon, 28 Apr 2008 21:35:00 +0200
From: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
Subject: Re: Talking to parallel port in 2.6 kernel without using parport
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <004301c8a95a$906666c0$b1333440$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <009501c89e28$3d7530f0$b85f92d0$@com>
	 <20080414133937.7080d30d@core> <006f01c8a4a7$82e37ea0$88aa7be0$@com>
	 <20080425181219.61e29b1f@core>
	 <ca2dc2820804251118j625abb76j100d165aee18a7c8@mail.gmail.com>
	 <004301c8a95a$906666c0$b1333440$@com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 8:06 PM, Kathy Frazier
<kfrazier@daetwyler-rd.com> wrote:
> Miguel,
>
>  Thanks for your response!  I took a look at ks0108.c.  You are right:  very
>  straightforward and a good reference.  I had added some other things based
>  on what I saw in /drivers/char/ppdev.c, lp.c and tipar.c.  After reviewing
>  yours, I am realizing I really don't need some of that, so I can simplify
>  mine.

I'm glad the code is helpful.

>
>  My biggest problem was that lp was loaded.  When I remove that, my call to
>  parport_register_device returns success!
>

Yeah, I made the same mistake two years ago too. ;)

>
>  Thanks for your help!
>

You are welcome!

--
Miguel Ojeda
