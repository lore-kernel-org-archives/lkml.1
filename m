Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYBJOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYBJOXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYBJOXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:23:12 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:50209 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751072AbYBJOXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:23:10 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] Silent compiler warning introduced by acea6852f32b8805e166d885ed7e9f0c7cd10d41 ([BLUETOOTH]: Move children of connection device to NULL before connection down.)
Date: Sun, 10 Feb 2008 16:21:21 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       torvalds@linux-foundation.org, hidave.darkstar@gmail.com,
       marcel@holtmann.org
References: <200802100457.20143.caglar@pardus.org.tr> <47AEC941.1070504@student.ltu.se>
In-Reply-To: <47AEC941.1070504@student.ltu.se>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1389388.A10r9HgZCm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802101621.26432.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1389388.A10r9HgZCm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

10 =C5=9Eub 2008 Paz tarihinde, Richard Knutsson =C5=9Funlar=C4=B1 yazm=C4=
=B1=C5=9Ft=C4=B1:=20
> S.=C3=87a=C4=9Flar Onur wrote:
> > Hi;
> >
> > Following patch silents
> >
> > net/bluetooth/hci_sysfs.c: In function `del_conn':
> > net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assi=
gnment used as truth value
> >
> > compiler warning introduced by commit acea6852f32b8805e166d885ed7e9f0c7=
cd10d41 ([BLUETOOTH]: Move children of connection device to NULL before con=
nection down.)
> >
> > Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
> >
> >  net/bluetooth/hci_sysfs.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
> > index e13cf5e..d2d1e4f 100644
> > --- a/net/bluetooth/hci_sysfs.c
> > +++ b/net/bluetooth/hci_sysfs.c
> > @@ -336,7 +336,7 @@ static void del_conn(struct work_struct *work)
> >  	struct device *dev;
> >  	struct hci_conn *conn =3D container_of(work, struct hci_conn, work);
> > =20
> > -	while (dev =3D device_find_child(&conn->dev, NULL, __match_tty)) {
> > +	while ((dev =3D device_find_child(&conn->dev, NULL, __match_tty)) !=
=3D NULL) {
> >  =20
> Why do you need '!=3D NULL'?

I thought its more readable than

while ((dev =3D device_find_child(&conn->dev, NULL, __match_tty))) {

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1389388.A10r9HgZCm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBHrwhmy7E6i0LKo6YRAs0qAKDWlaKdN3Uugz3rhgrUGVP6xcV09wCgx4AT
RCR/vqkuCFeAVndnAvikVFo=
=+lxn
-----END PGP SIGNATURE-----

--nextPart1389388.A10r9HgZCm--
