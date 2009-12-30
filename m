Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZL3I4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZL3I4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 03:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZL3I4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 03:56:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:55069 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752231AbZL3I4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 03:56:11 -0500
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1+10+5DEVG1zxhWZqKCAsMQmPtHBhTrifVCTB9JJG
	S1QLxSfyPLyX4G
Date: Wed, 30 Dec 2009 09:56:07 +0100
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
       "Len Brown" <lenb@kernel.org>
Subject: Re: [Bug #14889] System wakeup by time not working anymore
Message-ID: <20091230095607.7229baf4@highlander.home.lan>
In-Reply-To: <87k4w5u1fr.fsf@devron.myhome.or.jp>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	<srmJ8vMxKPH.A.BaC.ZwhOLB@chimera>
	<87k4w5u1fr.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1ShfqTKnzAlgstQpc0jatGp"; protocol="application/pgp-signature"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1ShfqTKnzAlgstQpc0jatGp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Dec 2009 02:36:56 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>=20
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14889
> > Subject		: System wakeup by time not working anymore
> > Submitter	: Malte Schr=C3=B6der <maltesch@gmx.de>
> > Date		: 2009-12-03 18:06 (27 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/=
linux-2.6.git;a=3Dcommit;h=3Dabd6633c67925f90775bb74755f9c547e30f1f20
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125986362631900&w=
=3D4
>=20
> Specified commit would break the pnp driver which is using
> driver->shutdown.
>=20
> Could you test this (untested) patch?

I tried to reproduce the problem, it looks like it is working now :)



--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/1ShfqTKnzAlgstQpc0jatGp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks7FacACgkQ4q3E2oMjYtXlLgCdF4SFjIdryZbFV6aJ55lf5y6q
I34An02Vrumsj195KVZoEAs6WsAnozKo
=odZa
-----END PGP SIGNATURE-----

--Sig_/1ShfqTKnzAlgstQpc0jatGp--
