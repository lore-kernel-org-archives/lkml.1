Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYGXUe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYGXUe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYGXUeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:34:20 -0400
Received: from server.drzeus.cx ([85.8.24.28]:50573 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751350AbYGXUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:34:19 -0400
Date: Thu, 24 Jul 2008 22:34:12 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Chuck Wolber <chuckw@quantumlinux.com>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Jake Edge <jake@lwn.net>, Michael Krufky <mkrufky@linuxtv.org>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 44/47] pxamci: fix byte aligned DMA transfers
Message-ID: <20080724223412.4ab223b1@mjolnir.drzeus.cx>
In-Reply-To: <alpine.LFD.1.10.0807241219480.3237@nehalem.linux-foundation.org>
References: <20080722230208.148102983@mini.kroah.org>
	<20080722231342.GA8282@suse.de>
	<20080722231735.GS8282@suse.de>
	<74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com>
	<20080723201258.GA26156@kroah.com>
	<alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org>
	<20080723203250.GA26454@kroah.com>
	<74d0deb30807240333l565eaf24uf695ce8d01597090@mail.gmail.com>
	<alpine.LFD.1.10.0807241219480.3237@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10597-1216931657-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10597-1216931657-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 12:22:56 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

>=20
> Pulling doesn't change the SHA1 ID of a commit, so _if_ it had been stabl=
e=20
> in the -mmc tree, it would have had the same commit in the kernel too.=20
> That's very much a design issue in git: the same commit always has the=20
> same ID. _ALWAYS_.
>=20
> So the fact that the ID changed implies that something odd happened in th=
e=20
> -mmc tree. Most likely a rebase. And again, this implies that somebody=20
> rebased already-public commits, since otherwise nobody would have ever=20
> even seen the original SHA1 ID.=20

Indeed I did. Things got shuffled around a bit when I updated the
patch queue with more stuff and the old attempt hadn't gotten merged
yet.

>=20
> Which is not good behaviour, _exactly_ because it makes it much harder fo=
r=20
> people to work together - suddenly a commit that got reported (for=20
> whatever reason: bug-report or 'please backport', it's all the same issue=
=20
> in the end) no longer exists.

I've always considered my "for-linus" branch to be primarily that, but I
guess I can be more careful so that other people can use it as well.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-10597-1216931657-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiI50cACgkQ7b8eESbyJLg/5gCfb3eZqB2BqaLbIPBr515f2xAF
Vc8An0aZsmONRRcsswb7EUdsm0xhVZJ0
=S3aQ
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10597-1216931657-0001-2--
