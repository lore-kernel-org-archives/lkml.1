Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZKHUHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZKHUHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZKHUHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:07:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53804 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755095AbZKHUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:07:13 -0500
Date: Sun, 8 Nov 2009 20:08:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matteo Croce <technoboy85@gmail.com>, Sven-Haegar Koch <haegar@sdinet.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091108200852.7f2cf092@lxorguk.ukuu.org.uk>
In-Reply-To: <20091108195158.GD4186@elf.ucw.cz>
References: <20091003072127.GC21407@elte.hu>
	<40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
	<4AF4526B.4060101@zytor.com>
	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
	<20091108173708.GF1372@ucw.cz>
	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
	<20091108181016.GB32364@elf.ucw.cz>
	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
	<20091108193618.GB4186@elf.ucw.cz>
	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>
	<20091108195158.GD4186@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Better to be sure that a NOPL whouldn't SIGILL your program, isn't
> > it?
> 
> SIGILL is easier to debug than NOPL mysteriously taking 100x time it
> should, sorry.

And a working 686 distribution is a great deal more useful to end users,
who outnumber you by a few million to one. It's a very sensible patch, or
perhaps you'd prefer we didn't say. And you forget the user "debug" for
a Geode + i686 without this will be "it hangs when I try and boot the
install CD"

It would probably also be worth having cmov fixups for the VIA C3 as well.

Alan
