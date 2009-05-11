Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZEKPJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZEKPJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZEKPIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:08:51 -0400
Received: from araneidae.co.uk ([62.3.233.233]:4577 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZEKPIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:08:51 -0400
Date: Mon, 11 May 2009 16:08:44 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Eric Miao <eric.y.miao@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Export GPIO control symbols from mfp-pxa2xx.c
In-Reply-To: <f17812d70905110739n1665120fncd6f6dcf798cae79@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0905111605020.12114@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905110740230.7176@venus.araneidae.co.uk> 
 <20090511070029.GA20226@infradead.org>  <Pine.LNX.4.64.0905110824560.7447@venus.araneidae.co.uk>
 <f17812d70905110739n1665120fncd6f6dcf798cae79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="682240-27675694-1242054524=:12114"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--682240-27675694-1242054524=:12114
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 May 2009, Eric Miao wrote:
> On Mon, May 11, 2009 at 3:28 PM, Michael Abbott <michael@araneidae.co.uk>=
 wrote:
> > On Mon, 11 May 2009, Christoph Hellwig wrote:
> >> On Mon, May 11, 2009 at 07:43:29AM +0100, Michael Abbott wrote:
> >> > With very lightweight board support providing a number of=20
> >> > uncommitted GPIO pins I found that my out of kernel driver needs to=
=20
> >> > call symbols that aren't actually exported. =C2=A0This patch adds th=
ese=20
> >> > exports.
> >> As usual we don't export symbols for out of tree drivers.
> >
> > I understand that's the default condition, but presumably there's no=20
> > compelling reason for the mfp configuration functions to be withheld=20
> > (I was simply trying to obey the obsolescence instructions in=20
> > pxa2xx-gpio.h!)
> >
> > As for bringing this driver in tree? =C2=A0Not a great deal of point, i=
n=20
> > this particular case, but I have no problem with doing that.
>=20
> I don't see many real requirements here to export them for the moment.=20
> By keeping these functions/symbols not-exported, I'd expect=20
> board-specific code (usually manipulation of these pins are=20
> board-specific) to be kept in the "board.c" as well, which I do think is=
=20
> a good practice.

That's kind of fair, but in the case where the board is a CPU module=20
rather than an entire system (which applies both for my XCEP module, the=20
Colibri modules, and others I'm sure) this isn't necessarily so=20
straightforward.

> Since your driver is out of the tree, you can certainly keep this change=
=20
> out of the tree as well :-)

Heh.  There should be an emoticon for sticking my tongue out ;^).  Ok, I=20
can live with that for the time being.
--682240-27675694-1242054524=:12114--
