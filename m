Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZFVOMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZFVOMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFVOLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:11:53 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36933 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZFVOLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:11:52 -0400
Date: Mon, 22 Jun 2009 16:11:47 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Speed of SDHCI subsystem
Message-ID: <20090622161147.0769731a@mjolnir.ossman.eu>
In-Reply-To: <20090617234550.116d7b7e@werewolf.home>
References: <20090519003750.461abe7d@werewolf.home>
	<20090603083341.7a2c84c8@mjolnir.ossman.eu>
	<20090617234550.116d7b7e@werewolf.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-23028-1245679913-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-23028-1245679913-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jun 2009 23:45:50 +0200
"J.A. Magall=C3=B3n" <jamagallon@ono.com> wrote:

>=20
> Thanks, now its clear it is related to hardware limits.
> I suppose this controler is a cheap one...
> Things in the Aspire One are these:
>=20

*snip*

> 04:00.0 System peripheral: JMicron Technologies, Inc. SD/MMC Host Control=
ler
> 04:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host C=
ontroller
> 04:00.3 System peripheral: JMicron Technologies, Inc. MS Host Controller
> 04:00.4 System peripheral: JMicron Technologies, Inc. xD Host Controller

That chip is capable of very high speeds but unfortunately the systems
aren't always properly wired for it so the high-speed mode was disabled
by default in the chips.

You can force it on by applying this patch:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3Da4b76193774b463b922cab2f92450efb20d29ef0;hp=3Dd6d8de33415ca7598f=
e66d933b6556fa8f89afe2

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-23028-1245679913-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko/kScACgkQ7b8eESbyJLhnpQCgx3+O+u9X2l7zTcSjylN3AWBV
sloAmwVkczAQKIq3xZ49Be/95pihUzXC
=0pLF
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-23028-1245679913-0001-2--
