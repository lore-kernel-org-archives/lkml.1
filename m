Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbYJMKOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbYJMKOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbYJMKCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:02:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37271 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763703AbYJMKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:02:12 -0400
Date: Mon, 13 Oct 2008 11:01:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Adam =?us-ascii?B?VGxhX19rYQ==?= <atlka@pg.gda.pl>, 7eggert@gmx.de,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LSU.0.999.0810131155280.5750@be1.lrz>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
	<20081012210140.15cecf78@merlin.oi.pg.gda.pl>
	<20081012212244.117852e0@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131155280.5750@be1.lrz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 11:59:52 +0200 (CEST)
Bodo Eggert <7eggert@gmx.de> wrote:

> On Sun, 12 Oct 2008, Alan Cox wrote:
> 
> > > That is why I propose usage of real_tty in ioctl() handling:
> > > 
> > > case TIOCGWINSZ:
> > >                 return tiocgwinsz(real_tty, p);
> > 
> > Congratulations we've finally got there - and that is exactly the code in
> > the current tty tree.
> 
> These patches are missing from 2.6.27. There you have:
> 
>     case TIOCGWINSZ:
>         return tiocgwinsz(tty, p);

Yes I know. The rules for the stable tree are that it has to go upstream
first. It has not gone upstream so it cannot go into the stable tree yet.
As and when Linus takes the relevant changes I will send a set to the
stable tree.

Alan
