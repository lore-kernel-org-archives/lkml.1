Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXGRAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXGRAIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXGRAIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:08:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39457 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbXGRAIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:08:23 -0400
Date: Wed, 18 Jul 2007 01:14:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Rene Herman" <rene.herman@gmail.com>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070718011436.2438dea6@the-village.bc.nu>
In-Reply-To: <2c0942db0707161615g4bdf825ar51464ba564a823e2@mail.gmail.com>
References: <8FO1e-2jW-35@gated-at.bofh.it>
	<8GVjY-PL-25@gated-at.bofh.it>
	<E1IA7j1-0000j9-I3@be1.lrz>
	<469A5D7C.5010904@gmail.com>
	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	<469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	<20070716235438.1bdd0722@the-village.bc.nu>
	<2c0942db0707161553u5d55724u82424b3ffbbd79f7@mail.gmail.com>
	<469BF9A8.20306@gmail.com>
	<2c0942db0707161615g4bdf825ar51464ba564a823e2@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 16:15:28 -0700
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> > Yes but it's also an argument that the 4K stacks don't make the _current_
> > situation without CONFIG_4KSTACKS selected worse and given that you trust
> > that current situation, that leaves you without your argument :-)
> 
> Heh :-). No, it's not a question of trust. First and foremost, it's
> that there are still users who say that they can crash a current
> 4k+interrupt stacks kernel, while the 8k without interrupt stacks is
> fine.

You forgot "most of the time". Its statistically less likely, which
merely means its evilly hard to debug
