Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbZABXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbZABXZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZABXY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:24:57 -0500
Received: from xsmtp0.ethz.ch ([82.130.70.14]:6593 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZABXY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:24:57 -0500
Message-ID: <495EA238.6000802@gmx.de>
Date: Sat, 03 Jan 2009 00:24:40 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081130)
MIME-Version: 1.0
To: tiwai@suse.de
CC: linux-kernel@vger.kernel.org, clip2@gmx.de
Subject: Re: current git does not shut down
References: <495E632C.6080100@gmx.de>
In-Reply-To: <495E632C.6080100@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3D488FBE726CB31921355AFE"
X-OriginalArrivalTime: 02 Jan 2009 23:24:54.0454 (UTC) FILETIME=[5179ED60:01C96D31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3D488FBE726CB31921355AFE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Dieter Ries schrieb:
> Hi,
>=20
> current git hangs when trying to shutdown or reboot my thinkpad T60,
> using gentoo 64bit. Just gets stuck while syncing hw clock, but I think=

> that is not what the real problem is.
>=20
> It works with 2.6.28 from december 25th, after commit 12a751a
>=20
> I am starting a bisect now, as it is perfectly reproducible it should
> work I think.

I have bisected the problem. Result is:

1289e9e8b42f973f2ab39e5f4f2239ff826c27e9 is first bad commit
commit 1289e9e8b42f973f2ab39e5f4f2239ff826c27e9
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Nov 27 15:47:11 2008 +0100

    ALSA: hda - Modularize HD-audio driver

I tried to revert it, but that failed because of too many files or
something.

I have tried to capture output via netconsole, but theres nothing.


The sound device in that laptop is:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)

what next?

cu
Dieter
--=20
3rd Law of Computing:
        Anything that can go wr
fortune: Segmentation violation -- Core dumped


--------------enig3D488FBE726CB31921355AFE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkleokIACgkQ5YzjaZZeXo3XngCfbzpVHHWw2MEpMMQ3sM+173go
kPQAn1Rql8UZuSy3VOateXZVze5CwVEy
=5KUo
-----END PGP SIGNATURE-----

--------------enig3D488FBE726CB31921355AFE--
