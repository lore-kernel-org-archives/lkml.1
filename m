Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZGJV41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZGJV41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZGJV4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:56:18 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZGJV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:56:17 -0400
Subject: Re: [PATCH 2.6.31] rfkill: allow toggling soft state in sysfs again
From: Johannes Berg <johannes@sipsolutions.net>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: John Linville <linville@tuxdriver.com>,
       Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Corentin Chary <corentin.chary@gmail.com>,
       debian-eeepc-devel@lists.alioth.debian.org,
       acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <507E47A184%linux@youmustbejoking.demon.co.uk>
References: <4A5716AA.5000903@ph.tum.de>
	 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com>
	 <4A5743AB.6090303@ph.tum.de>
	 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com>
	 <4A575119.9070505@ph.tum.de> <507E3B9268%linux@youmustbejoking.demon.co.uk>
	 <1247254899.21972.9.camel@johannes.local>
	 <507E47A184%linux@youmustbejoking.demon.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MvvnSk+qNM5ucUSE8A8Z"
Date: Fri, 10 Jul 2009 23:55:52 +0200
Message-Id: <1247262952.26071.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MvvnSk+qNM5ucUSE8A8Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 22:09 +0100, Darren Salt wrote:
> I demand that Johannes Berg may or may not have written...
>=20
> > Apparently there actually _are_ tools that try to set this in sysfs eve=
n
> > though it wasn't supposed to be used this way without claiming first.
>=20
> Then it should have been documented as such. I don't see anything about t=
his
> in Documentation/rfkill.txt (as found in 2.6.30), other than a vague
> statement that "Kernel handles events", which isn't exactly helpful :-\

Oh, it's not just that rfkill was horrible, the documentation matched :)
All the SHOUTING in it about what you must and must not do but nothing
actually helpful :)

> > *shrug*, I don't like it, but whatever...
>=20
> I do. It means that we have a nice simple text-based interface for use in
> scripts (for now), and a binary interface which is better suited to the l=
ikes
> of desktop applications.

Indeed, and as long as you expect to only use soft toggle... problem is
that you won't know whether it's soft-toggled or not while it's
hard-blocked (off)!

> > Please test & report.
>=20
> With the patch applied, Bluetooth toggling is working again, so you get t=
o
> add this:
>=20
> Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>

Ok, John, please pick up the patch.

johannes

--=-MvvnSk+qNM5ucUSE8A8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKV7jlAAoJEODzc/N7+QmahX0P/jKd86jntVSAeS8i5p08UnDf
cnueuwfGqLQHKtliVTcINIZXHciVMCDxaN6w0hE60Y27iBEvwLIuMypu5I1ekjNL
Kq4enHX//ag7bzske/c70QQ7KBU7ukFLjbx0uOAgk9+b40nzLu/4Ttur/dV9J7qZ
jtvW1Ch7ZX6AOeexZxC2dXF8Jxfnnvwvxr7ArUzpjcZaexaPyMfass8yN7nenXSL
N4lDw0cwnMMM5CgPxQDyMVoJ0uRzWh33es1Pw87ON4GYkNwIVVQQAPqGsoNp0LwR
vNinVWFQVRaabrUnJYsAwnHbrMDn1wfJacXDfXvhmhupaPzePwOkLA8LUP1iOa6A
Hr/EHNOIIr+Mb0bc7leM3lwQtS11ZnNWw24HIspmTxCEGeSkh9AK/Kbyga5gnnFs
J1fkqhWqObxs0bLs0vNp17aE4ZmjaBKZBsEmM4BfwxE/ty7Pjl7WzHBw5QF2bBbU
ADJ+Tw4p112JYRpvNwnD5TWyjS2yphyms8fsquNBDSDWAOB7OcDi/cH9wZ3ksGAv
TbeqresEv5ox5Va37q432wvlDvxTWOz5ntk9ZBobgxBR2hnu95XmD4N+4wyCTTQ7
5ATKijsJdeMof0afmmzEmDqhIE0MYYTrXsdF+nZfG5MsdtXoULuHiP831vzJWufh
wL2ZJezlCKazCeM/G7+S
=vG3B
-----END PGP SIGNATURE-----

--=-MvvnSk+qNM5ucUSE8A8Z--

