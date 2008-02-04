Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYBDGJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYBDGJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYBDGJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:09:39 -0500
Received: from clegg.madduck.net ([82.197.162.59]:59550 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYBDGJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:09:38 -0500
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 01:09:38 EST
Date: Mon, 4 Feb 2008 18:37:02 +1300
From: martin f krafft <madduck@madduck.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
Message-ID: <20080204053702.GA22183@lapse.madduck.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080203212155.GF12173@digitalkingdom.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20080203212155.GF12173@digitalkingdom.org>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux lenny/sid kernel 2.6.23-1-686 i686
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Robin Lee Powell <rlpowell@digitalkingdom.org> [2008.02.04.1021=
 +1300]:
>     /usr/share/mdadm/checkarray --cron --all --quiet

FYI:
http://git.debian.org/?p=3Dpkg-mdadm/mdadm.git;a=3Dblob;f=3Ddebian/checkarr=
ay

It basically does

  echo check > /sys/block/$array/md/sync_action

for all arrays.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
i feel like i'm diagonally parked in a parallel universe.
=20
spamtraps: madduck.bogus@madduck.net

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHpqR+IgvIgzMMSnURAgX4AKC0drk1VLzt5RK1nv8k7xplE0DOpgCeIqu+
vgMG9Ylrufkxx5dxXOpBipg=
=SCAs
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
