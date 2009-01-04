Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZADSVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZADSVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZADSU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:20:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52388 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbZADSU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:20:56 -0500
X-Greylist: delayed 897 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 13:20:56 EST
X-Sasl-enc: h4edJyF9h4AEiQW/r1lH+kwK6YZuPNCGtZKLlozDab66 1231092357
Message-ID: <4960FA79.7040301@imap.cc>
Date: Sun, 04 Jan 2009 19:05:45 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
 from unsigned long
References: <20090103124400.GA1572@ucw.cz>	<20090103201955.186974bb@lxorguk.ukuu.org.uk>	<20090103202740.GC1666@elf.ucw.cz> <20090103203044.0166b561@lxorguk.ukuu.org.uk>
In-Reply-To: <20090103203044.0166b561@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDAC0D0C6B9FA0D35080F21A1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDAC0D0C6B9FA0D35080F21A1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat 2009-01-03 20:19:55, Alan Cox wrote:
> On Sat, 3 Jan 2009 13:44:00 +0100
> Pavel Machek <pavel@suse.cz> wrote:
>=20
> > Linux relies on unsigned long to behave like atomic for read/write.
>=20
> Actually it isn't that simple and this advice shouldn't be given IMHO.
>=20
> unsigned long is not the same as atomic in several respects including
> ordering and caching of the result.

I'm confused. I remember distinctly being told, when merging the
Gigaset driver, that reading and writing of "pointer sized objects"
(I specifically remember that term) was assumed to be atomic across
large parts of the kernel anyway, that locking around a single read
or write of such an item was therefore pointless, and that "atomic_t"
only made sense if I wanted to use atomic_inc or atomic_dec on them.
The patches I submitted in following that advice, specifically commit
4d1ff582246de67b15e3cd2427a39875943ae895 "gigaset: remove pointless
locking" and 9d4bee2b9de9e30057a860d2d6794f874caffc5e "gigaset: atomic
cleanup", were confirmed to do the right thing and merged without any
objection.

What am I missing?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigDAC0D0C6B9FA0D35080F21A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFJYPqCQ3+did9BuFsRAvhUAJ9R+ye7B41uQnVHlGriM4SgSIDn4gCfVAZq
vPqzKIWrjYGRZVo8kCk6vHU=
=ORru
-----END PGP SIGNATURE-----

--------------enigDAC0D0C6B9FA0D35080F21A1--
