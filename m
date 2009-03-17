Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbZCQHyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbZCQHyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbZCQHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:54:30 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:38916 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbZCQHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:54:29 -0400
Date: Tue, 17 Mar 2009 08:54:24 +0100
From: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nico Schottelius <nico-linux-20090313@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090317075424.GD8777@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nico Schottelius <nico-linux-20090313@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
References: <20090313200657.GA4907@denkbrett.schottelius.org> <20090313204100.GA3554@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <20090313204100.GA3554@tuxdriver.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

John W. Linville [Fri, Mar 13, 2009 at 04:41:01PM -0400]:
> On Fri, Mar 13, 2009 at 09:06:57PM +0100, Nico Schottelius wrote:
> > Hello!
> >=20
> > I've two Lenovo X200 here, same config and same kernel version
> > (2.6.29-rc7-wl-ikn, from wireless-testing, v2.6.29-rc7-17155-g2f7ab92).
> >=20
> > One reboots after half a second after displaying a message Probing for =
edd
> > (or similar). I tried with and without edd=3Doff, no changes.
> >=20
> > The same happens with v2.6.29-rc7-32930-g5434dd7 (iwlwifi-2.6).
> >=20
> > Anyone an idea, what maybe the reason for that behaviour?
>=20
> No clue.  But since you clearly are comfortable with git and building
> your own kernels, perhaps you can use git bisect to suggest which
> commit is broken? :-)

It seems there's something different broken, all newly built
kernels are instantly rebooting. All are displaying the
"edd=3Doff" warning message.

The gcc version is slightly different (4.1.3 vs. 4.3.3, both Debian),
but I'm already running next-20090306 compiled with this compiler.

Has anyone a clue on howto debug the build environment or
debugging the kernel before it's getting booted?

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm/VzAACgkQuL75KpiFGIzdiACgtbFHcK3tNW5Fxmu73j6U5AUR
yCAAn1lu95OHvSj7E/RFePyv2GWZAsHB
=3eij
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
