Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYGBVrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYGBVrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYGBVqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:46:55 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbYGBVqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:46:54 -0400
Subject: Re: b43 locks the machine when resuming after suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Giacomo Mulas <gmulas@ca.astro.it>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <200807022340.31894.rjw@sisk.pl>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
	 <200807022340.31894.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yCWQ/Y/VtbOl3/VAURua"
Date: Wed, 02 Jul 2008 23:46:07 +0200
Message-Id: <1215035167.13270.8.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yCWQ/Y/VtbOl3/VAURua
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 23:40 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 2 of July 2008, Giacomo Mulas wrote:
> > I tried searching on the list for this, before posting, but searching t=
he
> > mailing list archives with keywords such as b43, suspend, resume... bri=
ngs
> > up such a ludicrous amount of threads that it's not realistic to check =
them
> > all, so just tell me what to look for if it's been asked already.
> >=20
> > Whenever I do a suspend to disk after using b43, the computer freezes h=
ard
> > as soon as it attempts again to access b43 after resume.
> >=20
> > Minimal how to reproduce the freeze:
> > 1) modprobe b43
> > 2) hibernate (using any suspend to disk, which one is irrelevant)
> > 3) resume
> > 4) ifconfig wlan0 up
> >=20
> > This has been happening (at least) since b43 was included in the mainli=
ne
> > kernel, on my Asus A6K laptop running an x86_64 kernel (now the latest
> > 2.6.25 stable release or compiled from the latest released debian sid
> > sources). The nvidia module is not responsible: I explicitely booted my
> > laptop in single user mode without any unnecessary modules, same result=
. It
> > does not happen using the windows driver with ndiswrapper (which I woul=
d
> > prefer to avoid for other reasons), so it definitely depends on b43 or
> > something it depends on. Unloading and reloading the b43 module and all=
 the
> > other modules it depends on does not change anything. Just loading the
> > module once, hibernating and resuming means freeze-up as soon as the mo=
dule
> > is actually initialised next time, regardless of it having been unloade=
d and
> > reloaded any number of times before or after the suspend-resume cycle. =
No
> > oopses, nothing on system logs, just instant freeze-up. Is there some
> > testing a user can do to help nailing this? I am not a kernel developer=
,
> > even if I am a decent C programmer.
> >=20
> > Please CC me on replies, I am not on the list.
>=20
> I think you need the appended patch, but it only applies to linux-next.

A different version has been merged into what will become 2.6.26. I'll
see what we can do about stable.

johannes

--=-yCWQ/Y/VtbOl3/VAURua
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIa/ccAAoJEKVg1VMiehFY1DYP/j3LYXguaWGBIN3/I3OWsUC9
tuSYSFQ+gmLnUU/V0EnqpgZl8J+1edkvCkDT2m1MB4v7TCelLXQe6cxCr0Vmhh4J
P4eALJa148ZXx0zx7Ca1/nJlKkOw20gw6OS4QnvJoA3ACVaxj7BCX9kSwj540nz4
hJJ24iTp5dx4hlAqT3/CdniHCSo+do9K9w+x4nTZ+DcLtXqW/2K0qCp/9SGJKWdx
C/6SSbcQ5ZfiYO24Lld9+8mFd+jMBnZh4ZqtUhzS1hRQND8Gq3VA8mc/Neh6SXq6
+srMlIlPUXInlqyvpXFOsujWfn2u+BU1jYJ5vIpnivkmttsCFMWcF7ZByoxv/WCs
+LKTNEh6XH3CqD4tHQM6hPNcEJnUZ6bAwwZd8vtdaoCh8TrGDwloMfHJPZD5pKjU
sdGmewvpR/tlofzNbQaVDo0zJkUXl/akgHvoxhT3tygug70Tc8j5TpBhaoMP2idg
NXum7h8dIrmpaE+GEibyMgFi77v+6hdcgmiUfXA8o+yxl3MzuL5dt+k/jurkTwGm
Hav4NT808gxj9L69aMG97LLPVr/LWkmD953IfJF0aMTFme73eHwXvqN0RhsIZ84E
sE5vHNd9wnfRbbrzUK1Tlhje+oFCSuxs2p9xNkcii/BRI1MwpcvnWN8a6YDYPQ0B
Ot45O3PgxDw+XtcBHH3N
=ufSb
-----END PGP SIGNATURE-----

--=-yCWQ/Y/VtbOl3/VAURua--

