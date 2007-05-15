Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbXEOLgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbXEOLgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbXEOLgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:36:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:58023 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756712AbXEOLgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:36:02 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX1+adaZVf1WaJejAutNYoOnmdc3XEZi8dVj3qdmPDS
	mGNdl+NZKAzIUj
Date: Tue, 15 May 2007 13:35:55 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070515133555.0111c063@SiRiUS.home>
In-Reply-To: <20070515123132.2e596d69@the-village.bc.nu>
References: <20070515125308.3a9f6442@SiRiUS.home>
	<20070515123132.2e596d69@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_UhZilkDhqoN0+dlNl5qfJ95;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_UhZilkDhqoN0+dlNl5qfJ95
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Di, 15.05.07 12:31 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 15 May 2007 12:53:08 +0200
> Thomas Kuther <gimpel@sonnenkinder.org> wrote:
>=20
> > Hi!
> >=20
> > Since 2.6.21 I have a problem with the it821x driver on my ITE 8212
> > controller.
> > Now I saw some updates to it821x in 2.6.22-rc1 and gave that a try,
> > but the problem persists.
>=20
> I've had multiple reports of this. I would recommend you use the
> libata driver. IT821x hasn't changed over the past few releases so
> its someting in the core IDE code that broke it [note it might not of
> course be that the problem is in the core code..].
>=20
> I have no plans at this point to debug the old IT821x driver due to
> time constraints, and if anyone wants to have a crack at debugging
> this and fixing it go for it.
>=20
> BTW: I also note you have the controller in smart mode but are not
> using the hardware raid functions. In that situation it generally
> runs faster (and does CD-ROM) if you flash the ATAPI firmware to the
> controller or boot with the noraid option "it8212.noraid=3D1"
>=20
> Alan

Hi Alan,
thanks for the suggestion.=20

I already tried pata_it821x and it failed to recognize the second
harddisk hdf. I use the controller only for additional harddrives, no
RAID, no cd-rom.

But I will try again. Maybe I just did something wrong then.

Thanks,
Thomas

--Sig_UhZilkDhqoN0+dlNl5qfJ95
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGSZsgMQFfAqZTGfwRAnKIAJ0aWG54PUUEl7/SCp4YOm632ntlMgCfQxFi
fEt1KXaRrsm7vHRbf8hjGdw=
=6stu
-----END PGP SIGNATURE-----

--Sig_UhZilkDhqoN0+dlNl5qfJ95--
