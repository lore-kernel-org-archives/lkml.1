Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZCLOUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZCLOUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbZCLOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:20:10 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41301 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbZCLOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:20:08 -0400
Date: Thu, 12 Mar 2009 15:20:03 +0100
From: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nico Schottelius <nico-linux-20090311@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net,
       Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [ipw3945-devel] X200 suspend status on -wl and -next
Message-ID: <20090312142003.GF30728@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nico Schottelius <nico-linux-20090311@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net,
	Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20090311073030.GA5284@denkbrett.schottelius.org> <200903110946.23280.rjw@sisk.pl> <20090311085229.GB4495@denkbrett.schottelius.org> <20090311184407.GG8761@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yRA+Bmk8aPhU85Qt"
Content-Disposition: inline
In-Reply-To: <20090311184407.GG8761@tuxdriver.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yRA+Bmk8aPhU85Qt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

John W. Linville [Wed, Mar 11, 2009 at 02:44:07PM -0400]:
> Any chance you'd like to try wireless-testing to help to isolate
> possible sources of this problem?
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.=
git

v2.6.29-rc7-17155-g2f7ab92 looks good (as in: wlan works after several
suspends and resumes). But it seems you do not add the full kernel version:

sgnx20002:/home/nico/wireless-testing# git describe
v2.6.29-rc7-17155-g2f7ab92
sgnx20002:/home/nico/wireless-testing# uname -r
2.6.29-rc7-wl-ikn

Which is the kernel built some seconds before.

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--yRA+Bmk8aPhU85Qt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm5GhMACgkQuL75KpiFGIxfSACgh6+5GybEho7oWUSBE9262NG7
a8AAoI0IizZyJoHIp4K9B5gQQa76PYeX
=yGb1
-----END PGP SIGNATURE-----

--yRA+Bmk8aPhU85Qt--
