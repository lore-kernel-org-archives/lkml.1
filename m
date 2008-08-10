Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYHJGlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYHJGlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYHJGlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:41:09 -0400
Received: from mx33.mail.ru ([194.67.23.194]:32555 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYHJGlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:41:08 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc2: unable to suspend - one task not freezed
Date: Sun, 10 Aug 2008 10:40:54 +0400
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <200808091018.32053.arvidjaar@mail.ru> <200808092353.56006.rjw@sisk.pl>
In-Reply-To: <200808092353.56006.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2320365.VJtBkp5mys";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808101041.00919.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2320365.VJtBkp5mys
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 10 August 2008, Rafael J. Wysocki wrote:
> On Saturday, 9 of August 2008, Andrey Borzenkov wrote:
> > 2.6.27-rc2 + unrevert of e872154921a6b5256a3c412dd69158ac0b135176
> > (USB: don't explicitly reenable root-hub status interrupts) + fix
> > of above from Alan Stern (OHCI: fix system hang caused by earlier patch=
).
>=20
> Why do you have to unrevert commit e872154921a6b5256a3c412dd69158ac0b1351=
76
> exactly?
>=20

This commit caused my system to hang after ohci_usb was loaded. It was
reverted in 2.6.26 after my report. Later Alan sent the fix for it which I
have been testing. This commit (with fix) is scheduled back in 2.6.27.

This is regression because 2.6.26 + two patches mentioned above suspend and
resume just fine.=20

> > System cannot be suspended - some task cannot be freezed. I think it is
> > khubd ...
>=20
> Yes, it is.
>=20
> It looks like khubd is running in a loop without checking TIF_FREEZE.
>=20
> > dmesg and config attached.
>=20
> Hm.  Is this 100% reproducible?
>=20

So far yes.


--nextPart2320365.VJtBkp5mys
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiejXcACgkQR6LMutpd94wGjwCgsIWjnn5Frtm3CCkvHsYmkLL2
lyIAni8F0Agz1CjCyahP2RC8YkByPid7
=gMbD
-----END PGP SIGNATURE-----

--nextPart2320365.VJtBkp5mys--
