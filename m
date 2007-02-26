Return-Path: <linux-kernel-owner+w=401wt.eu-S965039AbXBZKQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039AbXBZKQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965071AbXBZKQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:16:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:35628 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbXBZKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lti0K/PunBJGUtKBMP7WD8C0EmAgrpvLGEqAKChAiPEQ9nCc02pttnIZKcE9/abFDGQk3xlAuu0q7pZ9FpKz4kdfLwkSqTSAXfl7z9o3ab/Oyb+pXlguyKYoJ32+Vr0pMs7DMz45T2GvS8rBcatMJy5AEOkUfeXawOfwywL6oNE=
Message-ID: <f2b55d220702260216j17003b19l44d8275d9e87950@mail.gmail.com>
Date: Mon, 26 Feb 2007 02:16:20 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Pavel Machek" <pavel@ucw.cz>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <20070225191028.4f0ecdfb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	 <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
	 <20070225104211.GB2045@elf.ucw.cz>
	 <f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
	 <20070225135208.6e2eab9c@lxorguk.ukuu.org.uk>
	 <f2b55d220702250621h1877f8e8x19293cc8b95bf56@mail.gmail.com>
	 <20070225191028.4f0ecdfb@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > Busy-wait loops were a rhetorical flourish, I grant you.
>
> Thats a complicated fancy way of saying you were talking rubbish ?

No, it's a way of saying "yes, there are deliberate performance limits
in the driver code, but they're harder to explain than busy-wait
loops".  Ask anyone who has worked inside a peripheral device company,
especially one that sells into the OEM/ODM market.  It is
_standard_practice_ to fab a single chip design that runs as fast as
you know how, and then dumb it down in firmware to meet the spec that
the board vendor is willing to pay for.  If you don't, those guys will
steal you blind, diverting chips intended (and priced) for low-margin
commodity mobos into the high-margin gamer market.

There is, however, a gross error in my latest explanation of why ATI
and NVidia don't provide full driver source code.  Really an
embarrassing oversight.  Wouldn't blame you for ripping me a new one
over it.  Pity you were busy taking cheap shots at my tortured syntax.
 Here's what I forgot:

Macrovision.

Not that any of the stuff about market segmentation, retail margins,
and the FCC isn't true, but it's not the scariest thing in a PC
graphics vendor's world.  The scariest thing in their world is the
possibility that it will become widely known how to defeat the
"Macrovision in, Macrovision out" mechanism (and the equivalent for
DVD playback and HDMI).

Just so you know I'm not making this up:  I know where the "defeat
Macrovision" bits are on certain devices, and if I told you, Jack
Valenti would personally come to my house and ream me out with a
red-hot poker.  (Alan, that's a special kind of "talking rubbish"
known as "comic hyperbole".  I learned it from your Monty Python.  :-)
 Seriously though, those bits are in there, they're software
controlled (or were when I last fiddled with set-tops), and there are
large security deposits and large threats of being shut out of the
MPEG/DVD and DVI/HDMI patent pools riding on the graphics card makers'
promises to keep them hidden.  Not that they're that hard to reverse
engineer -- but they're not going to help you.

You're going to say this cat is already out of the bag; a quarter of
the teenagers in developed countries have the MaD sKiLlZ to rip DVDs
and pass them around on BitTorrent like so much 1970s kiddie porn.
And maybe that's so; but imagine next year's family PC with the HDMI
port attached to the 62" HDTV, dual-booting pirated Windows for
pirated first-person shooters and Linux for pirated DVDs, both of them
conveniently pre-installed by the neighborhood store-front beige-box
assembler.  That's the MPAA's worst nightmare -- and frankly, I'm not
too keen on it either.  I like seeing old movies lovingly restored and
published on DVD.  I'd like to see them come out someday in 16:9 720p,
preferably while my eyes are still good enough to tell the difference.

Anyway, that's more than enough purple prose.  Believe what you want to believe.
