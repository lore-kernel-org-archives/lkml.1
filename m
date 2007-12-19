Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbXLSTPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbXLSTPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXLSTOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:14:54 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:56382 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbXLSTOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:14:52 -0500
Date: Wed, 19 Dec 2007 20:14:39 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: a1426z@gawab.com, indan@nul.nu, david@davidnewall.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071219201439.129c3772@astralstorm.puszkin.org>
In-Reply-To: <200712192111.DDC12949.HFOtMOOSVLQFFJ@I-love.SAKURA.ne.jp>
References: <47650A4C.4000708@davidnewall.com>
	<200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
	<54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
	<200712171605.31084.a1426z@gawab.com>
	<20071218162228.79f75395@astralstorm.puszkin.org>
	<200712192111.DDC12949.HFOtMOOSVLQFFJ@I-love.SAKURA.ne.jp>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QlALGDavvODzjf945Oatgd4";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QlALGDavvODzjf945Oatgd4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Dec 2007 21:11:11 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Hello.
>=20
> Radoslaw Szkodzinski (AstralStorm) wrote:
> > Actually, who needs to create device nodes? Just prohibit everyone from
> > creating them, except "installer" and "udev" personality.
> > This means removing CAP_MKNOD on a global scale.
>=20
> What happens if the root tampers udev's configuration file?
> The udev will create inappropriate (i.e. filename with unexpected attribu=
tes)
> device nodes, won't it?

Yes. But root doesn't need access to these files, at least not usually.
Create a separate user for editing config files - much lower
probability of breakage. Remove almost all capabilities from root and
profit.

> After all, revoking CAP_MKNOD is not enough for guaranteeing
> filename and its attributes.
>=20
> This filesystem is designed to guarantee filename and its attributes,
> but this filesystem has additional access control capability.
> You can forbid mknod/unlink /dev/null if you want nobody to do so.
> You can forbid chmod/chown /dev/null if you want nobody to do so.

You can forbid all operations on /dev (except udev) with an ACL.
So, what is the need for this filesystem?

--Sig_/QlALGDavvODzjf945Oatgd4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHaW2lBlhXA0ALOYMRAt9ZAKCN/1UToW+z4Qfa0nO4U20r8vm/gwCghqt0
fRGEDZq5Gw5bfkLrbxmETgc=
=hsFR
-----END PGP SIGNATURE-----

--Sig_/QlALGDavvODzjf945Oatgd4--
