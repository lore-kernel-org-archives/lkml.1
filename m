Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYJNPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYJNPpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJNPpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:45:45 -0400
Received: from server.drzeus.cx ([85.8.24.28]:47738 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751296AbYJNPpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:45:45 -0400
Date: Tue, 14 Oct 2008 17:45:36 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081014174536.1353d17e@mjolnir.drzeus.cx>
In-Reply-To: <20081014025453.617f2ef8@werewolf.home>
References: <20081014025453.617f2ef8@werewolf.home>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-6045-1223999144-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6045-1223999144-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Oct 2008 02:54:53 +0200
"J.A. Magall=C3=B3n" <jamagallon@ono.com> wrote:

> Hi...
>=20
> More problems with git3. The left SD card reader is not detected on the O=
ne.
> With a working kernel (distro 2.6.27):
>=20
> Oct 14 02:44:27 one kernel: mmc0: error -84 whilst initialising SD card
>=20
> Any ideas ?
>=20

-84 is -EILSEQ, which is some kind of bit error. Since you're running a
JMicron controller, I'm guessing that something in your system isn't
handling the higher speed (we forcefully enable highspeed on the
Jmicron controll now).

What machine is this? Have you tested more than one card?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6045-1223999144-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkj0vqUACgkQ7b8eESbyJLgtUACfdcKxR3o+AqyAQ5ySAbVi5KNi
looAn0BhOMsNNe0STlO5NdRKzg5uycm4
=+K/e
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6045-1223999144-0001-2--
