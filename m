Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYA1TWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYA1TWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYA1TV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:21:58 -0500
Received: from mx48.mail.ru ([194.67.23.226]:1691 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYA1TV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:21:57 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
Date: Mon, 28 Jan 2008 22:21:49 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Richard Heck <rgheck@bobjweil.com>, linux-kernel@vger.kernel.org
References: <200801272122.21823.gene.heskett@gmail.com> <20080128185345.CF0A51871238@smtp03.mtu.ru> <200801281409.05839.gene.heskett@gmail.com>
In-Reply-To: <200801281409.05839.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1491252.XydvviUaXZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801282221.53303.arvidjaar@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1491252.XydvviUaXZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 January 2008, Gene Heskett wrote:
> On Monday 28 January 2008, Andrey Borzenkov wrote:
> >Richard Heck wrote:
> >> Daniel Barkalow wrote:
> >>> Can you switch back to old IDE to get your work done (and to make sure
> >>> it's not a hardware issue that's developed recently)?
> >>
> >> I think it'd be really, REALLY helpful to a lot of people if you, or
> >> someone, could explain in moderate detail how this might be done. I
> >> tried doing it myself, but I'm not sufficiently expert at configuring
> >> kernels that I was ever able to figure out how to do it.
> >
> >well, here on Mandriva I
> >
> >1) compile both IDE and libata as modules
> >2) create initrd that contains either IDE or libata modules
> >3) use labels for file system mounts, swaps and resume device.
> >
> >
> >Now 1) should be pretty straightforward (I could send you config if you
> >like, it is stripped down to bare minimum on my system, you will have to
> >check drivers for your hardware). 2 and 3 are obviously distribution
> >dependent. I can explain how to do it on Mandriva that ATM has near to
> >perfect support for addressing devices via label/UUID; also ide/scsi/ata
> >switch is trivial using Mandriva mkinitrd.
> >
>=20
> I already build as modules, and it would be relatively easy to make 2 boo=
t=20
> stanza's that used the different initrd's if there were examples that cou=
ld=20
> be used as 'excludes' when building the initrd's.  Is such a creature=20
> breedable?
>=20

I am not sure I understand a question (it is not my native language) but he=
re I=20
simply do

mkinitrd --omit-ide-modules --preload pata_ali --preload sd_mod ...

or

mkinitrd --omit-scsi-modules --preload alim15x3 --preload ide-disk ...

If you ask how --omit part is implemented I happily send you mkinitrd scrip=
t.

--nextPart1491252.XydvviUaXZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkeeK04ACgkQR6LMutpd94xbOACeOjrQs2WzR7GQ7DAdWqi7H1tI
zHMAniKjwoWxHS+fLbziGfGCaqElD7W4
=L17v
-----END PGP SIGNATURE-----

--nextPart1491252.XydvviUaXZ--
