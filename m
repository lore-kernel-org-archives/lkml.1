Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbXD0Vjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbXD0Vjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXD0Vjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:39:46 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:39721 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXD0Vjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:39:45 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070427145507.GP22250@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <20070426224005.GA21926@elf.ucw.cz>
	 <84144f020704262241s5bcfc043k55f9d60e368b3c9e@mail.gmail.com>
	 <20070427145507.GP22250@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zch4jxUWvr1/A4KzRaRy"
Date: Sat, 28 Apr 2007 07:39:45 +1000
Message-Id: <1177709985.4737.166.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zch4jxUWvr1/A4KzRaRy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-27 at 16:55 +0200, Pavel Machek wrote:
> On Fri 2007-04-27 08:41:56, Pekka Enberg wrote:
> > On 4/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > >Now, it would be _very_ nice to be able to snapshot system and
> > >continue running, but I just don't see how to do it without extensive
> > >filesystem support.
> >=20
> > So what kind of support do we need from the filesystem?
>=20
> "forcedremount ro, not telling anyone, not killing processes" would do
> the trick. FS snapshots might do.

It sounds to me more like Pekka is thinking of checkpointing support. If
that's the case, then remounting filesystems isn't going to be an
option. You want to freeze them for just long enough so that you can
determine what needs saving in the checkpoint. You certainly don't want
to make rw file handles ro and so on.

Nigel

--=-Zch4jxUWvr1/A4KzRaRy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMm2hN0y+n1M3mo0RAmdHAJwI+v0TBymaXWkrBQ0CEV1VBNX4awCg6xEa
w0Tmcy6Momy8gd5DwVsFhVo=
=Gw2u
-----END PGP SIGNATURE-----

--=-Zch4jxUWvr1/A4KzRaRy--

