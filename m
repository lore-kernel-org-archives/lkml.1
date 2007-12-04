Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbXLDRqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbXLDRqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXLDRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:45:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:41412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751547AbXLDRpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:45:51 -0500
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX1+OxQppUCSO3RyyIA2B2Qs/EBzwX9l2sWISS+zkrn
	otelKN/AW5P/Xw
Date: Tue, 4 Dec 2007 18:45:38 +0100
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <peterz@infradead.org>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9291] pdflush stuck in D state with
 v2.6.24-rc1-192-gef49c32
Message-ID: <20071204184538.6f5f0278@sirius>
In-Reply-To: <20071204102802.GA14490@elte.hu>
References: <20071031175318.GU25561@iucha.net>
	<E1InUH6-0001vE-1Y@localhost>
	<20071101122558.GX25561@iucha.net>
	<E1InZht-0004lr-NN@localhost>
	<20071101141414.GZ25561@iucha.net>
	<E1InlPV-0001f1-SL@localhost>
	<20071102021002.GF25561@iucha.net>
	<E1Inw51-0001e8-PS@localhost>
	<20071102133239.GI25561@iucha.net>
	<loom.20071111T133858-314@post.gmane.org>
	<20071204102802.GA14490@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Q3boc3DBC+epJXGiCmEj2ch";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Q3boc3DBC+epJXGiCmEj2ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Di, 04.12.07 11:28 Ingo Molnar <mingo@elte.hu> wrote:

>=20
> * Thomas <gimpel@sonnenkinder.org> wrote:
>=20
> > I can confirm this issue too on any .24-rc. I'm also using reiserfs
> > on a LVM.
> >=20
> > And there is one more user on Gentoo forums having the same issue.=20
> > http://forums.gentoo.org/viewtopic-t-612959.html
> >=20
> > So you are not alone, florian.
>=20
> any progress on this issue? Seems a bit stalled.
>=20
> 	Ingo

For me the two patches
 * mm-speed-up-writeback-ramp-up-on-clean-systems.patch=20
 * reiserfs-writeback-fix.patch
solved the issue.

IIRC one was from this thread, the other from
http://lkml.org/lkml/2007/10/23/93

So since 2.6.24-rc2-git5 all is fine again. No problems since.

Regards,
Thomas

--Sig_/Q3boc3DBC+epJXGiCmEj2ch
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHVZJLMQFfAqZTGfwRAk5NAJ9UNHed2C9ps6yVN9+G/UaSA3RQ8wCfawJr
gvL1RCgny2srPfJgq6e/hNI=
=U6kW
-----END PGP SIGNATURE-----

--Sig_/Q3boc3DBC+epJXGiCmEj2ch--
