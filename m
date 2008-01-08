Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbYAHRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbYAHRU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYAHRUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:20:14 -0500
Received: from systemlinux.org ([83.151.29.59]:36201 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYAHRUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:20:12 -0500
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 12:20:12 EST
Date: Tue, 8 Jan 2008 17:48:47 +0100
From: Andre Noll <maan@systemlinux.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108164847.GA16462@skl-net.de>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16:07, Tuomo Valkonen wrote:

> I hate it: every time Linux crashes, e.g. due to power failure, it takes
> almost an hour to boot, because the kernel has decided to corrupt the=20
> superblock to indicate that it's been years since last file system=20
> check.

Use tune2fs to deactivate checking.

> And obviously the crappy init system provides no simple way to=20
> stop the checking, to put it in the background, or whatever.

Modify the init scripts or use another distro.

> The FOSS herd is totally concentrated on creating a WIMP idiot box --
> a cheap plastic clone of Windows -- instead of fixing such fundamental
> problems.
> Windows, by the way, boots like a blaze compared to woeful Linux crap
> (even without the very definition of pure shit: udev, which the crap
> known as Linux practically requires these days).

Don't use udev then. Good old static dev works fine if you have a fixed
set of devices.

> A partial contributor to the slow fsck process is:
>=20
>     hde: ST3160023AS, ATA DISK drive
>     hde: applying pessimistic Seagate errata fix
>=20
>     # hdparm -t /dev/hde
>     /dev/hde:
>      Timing buffered disk reads:   48 MB in  3.01 seconds =3D  15.96 MB/s=
ec

You're using the sil3112 driver? Edit its blacklist and remove the
entry for your drive. That gives you the usual speed.

>     Linux noi 2.6.14 #1 PREEMPT Sun Oct 30 20:18:48 EET 2005 i686 GNU/Lin=
ux
>=20
> I've tried upgrading, and failed: the megatonne monolith with a gazillion
> hidden options (and totally worthless make oldconfig)

Gradually upgrade to 2.6.15, 2.6.16...

> is impossible to compile these days,

Check your tool-chain. Many people compile recent kernels with no problems.

> and the distros' stock kernel are utter and total crap
> that load drivers in wrong order etc., and are difficult to configure
> (demanding crap that demands udev to edit their initrds).

Use a kernel.org version.

> Not to even speak of the udev-demanding scsi-mapping insanity of SATA
> etc. devices these days.

Nobody forces you to use udev. Moreover, you can write your own udev
rules that match your expectations.

> I've had it with Linux. It's no longer for power users. It's so complex
> that it's only for idiot users that are content with the shoddy defaults,
> and (paid) developers.

You're not ranting about Linux but about your Distro. Complain on
the corresponding distro-specific mailing list, use another distro
and and stop whining.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHg6lvWto1QDEAkw8RArL5AKCfCEZD4luSlF8nJR7EJwkO15l2tACgoLc9
i5ajLx1iSuSi1iIsN/OYEfI=
=y0Qc
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
