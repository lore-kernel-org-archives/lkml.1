Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXLIDDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXLIDDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 22:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXLIDDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 22:03:05 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33027 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753337AbXLIDDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 22:03:04 -0500
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20071208020722.9c7d91d0.akpm@linux-foundation.org>
References: <1197059904.15428.15.camel@localhost>
	 <20071207150251.a0dbae23.akpm@linux-foundation.org>
	 <1197068983.15428.29.camel@localhost>
	 <20071207152249.360af326.akpm@linux-foundation.org>
	 <1197090093.7157.2.camel@localhost>
	 <20071208020722.9c7d91d0.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-00f9FNs4S+O8bXYPfJrx"
Date: Sat, 08 Dec 2007 20:02:54 -0700
Message-Id: <1197169375.7352.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071208/1J1CRX-0004iB-BO-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-00f9FNs4S+O8bXYPfJrx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2007-12-08 at 02:07 -0800, Andrew Morton wrote:
> On Fri, 07 Dec 2007 22:01:33 -0700 Zan Lynx <zlynx@acm.org> wrote:
>=20
> >=20
> > On Fri, 2007-12-07 at 15:22 -0800, Andrew Morton wrote:
> > > On Fri, 07 Dec 2007 23:09:43 +0000
> > > Zan Lynx <zlynx@acm.org> wrote:
> > [cut]=20
> > > > > > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again=
, but I
> > > > > > only get read rates of 1.6 MB/s.  When it used to work in 2.6.2=
0 I got
> > > > > > at least 16 MB/s.  The card itself is capable of 30+ in the USB=
-2
> > > > > > reader.
[cut]
> argh.  OK.  And Linus's current tree is OK, yes?
>=20
> In which case we should be OK for 2.6.24 and I guess we can hope like hec=
k
> that the dud patch doesn't leak into mainline.  Hopefully Alan will get
> some time to look into it before 2.6.25 opens.

Linus' tree is also broken.

I tried a Linus 2.6.24-rc4 and it acts the same way, with a very slow
transfer rate. =20

I also tried 2.6.24-rc4 with the older not-libata PATA drivers and it is
broken.  dmesg had a line about the CF card detected as hda,
but /sys/block did not have hda and /dev/hda did not function.

I will try the patches you mentioned, but I think I may also have to
work backward through kernel versions until I find the last one where
the PCMCIA hd{a,b,c,d,e} drivers worked.
--=20
Zan Lynx <zlynx@acm.org>

--=-00f9FNs4S+O8bXYPfJrx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHW1reG8fHaOLTWwgRApdMAJ40DD7rBfGI683F32oRMr2JjtlFsQCeP2Vs
iIlnID95w9z9u7mrRMMoUjk=
=Ruya
-----END PGP SIGNATURE-----

--=-00f9FNs4S+O8bXYPfJrx--

