Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYHJKtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYHJKtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 06:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYHJKti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 06:49:38 -0400
Received: from mx7.mail.ru ([194.67.23.27]:15524 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYHJKth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 06:49:37 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc2: unable to suspend - one task not freezed
Date: Sun, 10 Aug 2008 14:49:27 +0400
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <200808091018.32053.arvidjaar@mail.ru> <200808092353.56006.rjw@sisk.pl>
In-Reply-To: <200808092353.56006.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3947003.mUOmXrbzyO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808101449.31845.arvidjaar@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3947003.mUOmXrbzyO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Looks like I messed something up when rebasing to 2.6.27-rc2. I now
made new build and it works. Sorry for the noice.

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
> Rafael
>=20
>=20



--nextPart3947003.mUOmXrbzyO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiex7gACgkQR6LMutpd94zNlgCeL49U38RKEo+kU0FZtxstl55D
0ggAoNB3c7qffSIHL+a9k7xH0hRBNpyY
=swGS
-----END PGP SIGNATURE-----

--nextPart3947003.mUOmXrbzyO--
