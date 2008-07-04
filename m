Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYGDNQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYGDNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYGDNQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:16:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44739 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbYGDNQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:16:19 -0400
Date: Fri, 4 Jul 2008 23:16:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 4
Message-Id: <20080704231610.98118766.sfr@canb.auug.org.au>
In-Reply-To: <20080704114648.13374869@lxorguk.ukuu.org.uk>
References: <20080704195529.7f56e768.sfr@canb.auug.org.au>
	<20080704114648.13374869@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Jul_2008_23_16_10_+1000_zmKBVlk2iI=6L89l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jul_2008_23_16_10_+1000_zmKBVlk2iI=6L89l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 4 Jul 2008 11:46:48 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > 	ttydev: fix pamc_zilog for tty pointer move
> > 	ttydev: sparc fix for tty move
> > 	ttydev: sparc32 fix for tty move
> > 	atmel_serial: Fix tty_port breakage
>=20
> Got these

Good.  There are more broken drivers - check out
http://kisskb.ellerman.id.au/linux-next

> > http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
> > are tracking the linux-next tree using git, you should not use "git pul=
l"
> > to do so as that will try to merge the new linux-next release with the
> > old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> > (see below).
>=20
> bash-3.2$ git fetch linux-next
> remote: error: refs/heads/history does not point to a valid object!
> remote: error: refs/heads/master does not point to a valid object!
> remote: error: refs/tags/next-20080704 does not point to a valid object!
>=20
> (on top of a clean current Linus git pull)

Were you using
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git or
http://www.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git ?  The
git one works for me and the http does as well now that I have updated
the server info (though I neglected to try it before doing the update).

Thanks for the heads up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Jul_2008_23_16_10_+1000_zmKBVlk2iI=6L89l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhuIpoACgkQjjKRsyhoI8wEFwCfZ6XFUCILr1J3sh63g4Dh1ocA
SOAAn2mXYfhECTnxvnDgjI4y2QMMCT34
=FxeX
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jul_2008_23_16_10_+1000_zmKBVlk2iI=6L89l--
