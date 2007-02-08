Return-Path: <linux-kernel-owner+w=401wt.eu-S1422842AbXBHF4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422842AbXBHF4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422880AbXBHF4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:56:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22988 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422842AbXBHF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lpDUXxUmBnQTsMdvfIH/oIxkyadnLMWDIiWqr73IbYmrQ0zySJWf/OQW1JIL7URCp0JOfPs+gxpphssUxJkDzFMOfmN7GsTS89clf+ngREsKg0CBOr7CGsiinoEpkGq8chZlOHMT/wtrIsQdUuNuYQ1jx0o7jTpCz9i9p1DOlTc=
Message-ID: <8bd0f97a0702072156q640d49b8of5f81a60b380ef81@mail.gmail.com>
Date: Thu, 8 Feb 2007 00:56:17 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: dd
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Roman Zippel" <zippel@linux-m68k.org>, sam@ravnborg.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kai Germaschewski" <kai@germaschewski.name>
In-Reply-To: <20070208052439.GL22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	 <Pine.LNX.4.64.0702071846180.14457@scrub.home>
	 <20070207220435.GC22699@flower.upol.cz>
	 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
	 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
	 <20070207203047.51a95ad0.akpm@linux-foundation.org>
	 <20070208052439.GL22699@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> > Check to see if `${CROSS_COMPILE}mkimage` exists and if not, fall back to
> > the standard `mkimage`
>
> Why this can't be done by
>
>   PATH=$CROSS_COMPILE:$PATH
>
> in your environment?

because it wouldnt matter ?  the tool is called
"$CROSS_COMPILE-mkimage", it isnt $CROSS_COMPILE_PATH/mkimage

> > The Blackfin toolchain includes mkimage, but we dont want to namespace
> > collide with any of the user's system setup, so we prefix it with our
> > toolchain name.
>
> If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
> with "dash" (very good `sh' equivalents) will fail. I would recomend to
> use "which" command (btw, Debian has `sh' version of it), if you
> concerned about size and performance.
>
> Nack + proposition to move from `bash' to `sh'.

the script already uses "#!/bin/bash" and the patch doesnt change any
of the existing conventions ... so if you want to rewrite the existing
code to be POSIX compliant, then do so so i can add back in support
for $CROSS_COMPILE-mkimage
-mike
