Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbXGEUmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbXGEUmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbXGEUm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:42:27 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47680 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXGEUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:42:26 -0400
To: Bodo Eggert <7eggert@gmx.de>
Cc: Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it>
	<8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz>
	<20070705192002.GB11204@DervishD>
From: Nix <nix@esperi.org.uk>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Date: Thu, 05 Jul 2007 21:42:17 +0100
In-Reply-To: <20070705192002.GB11204@DervishD> (DervishD's message of "Thu, 5 Jul 2007 21:20:02 +0200")
Message-ID: <87vecyeg5y.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jul 2007, DervishD spake thusly:
>  * Bodo Eggert <7eggert@gmx.de> dixit:
>> Standardisation is good, but autotools (as they are used) usurally isn't.
>
>     Usually, by picking other's project configure.in and tweak blindly.

You'd think they'd never heard of autoscan...

>     My favourite is when the project doesn't honor --*dir options. Or
> when the project breaks badly if you put some files in different places
> by using configure options... That's good standarization.

That's a broken project, I'd say. But you have a point, which is that
autoconf does too little, and automake plugs the gaps badly (and let's
not even talk about the abomination which is libtool).

>> Configuring the build of an autotools program is harder than nescensary;
>> if it used a config file, you could easily save it somewhere while adding
>> comments on how and why you did *that* choice, and you could possibly
>> use a set of default configs which you'd just include.
>
>     Looks like CMake...

That's cool :) thanks to KDE using it everyone's autobuilders are having
to adapt to cmake anyway, and it's not hard and you only have to do it
once.

>> I'm really really happy if I read 'edit Makefile.conf and run make...'.
>
>     Again, this looks like CMake...

:)

My only real grouch with cmake is that the authors have invented a
language with so bloody many capital letters in it. Looking at cmake
macros makes my eyes bleed even more badly than looking at the mass of
involuted nested brackets in configure.ac's, and that's a difficult
thing to do. (It's less portable than autoconf-generated configure
scripts but most of autoconf's portability tests are for long-dead
systems anyway, and as you said util-linux of all projects doesn't give
a damn. I don't really care if software isn't portable to an Interactive
box --- EOLed in 1992 --- or a SunOS 4.0 or HP-UX 8 box.)

There's a good reason most text is lowercase. Even Lisp moved to
lowercase a long time ago...
