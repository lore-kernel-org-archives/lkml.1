Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbYDCHPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbYDCHPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761567AbYDCHPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:15:08 -0400
Received: from clegg.madduck.net ([82.197.162.59]:56051 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761933AbYDCHPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:15:06 -0400
X-Greylist: delayed 1657 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 03:15:06 EDT
Date: Thu, 3 Apr 2008 08:46:53 +0200
From: martin f krafft <madduck@madduck.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Recreating RAID1 after the reckless mdadm usage
Message-ID: <20080403064653.GA2410@piper.oerlikon.madduck.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <47F46F3A.3060105@permonline.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <47F46F3A.3060105@permonline.ru>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux lenny/sid kernel 2.6.24-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Artem S. Tashkinov <birdie@permonline.ru> [2008.04.03.0746 +020=
0]:
> mdadm --create --assume-clean --verbose /dev/md0 --level=3D1 --force =20
> --raid-devices=3D2 /dev/sda1 missing (which is obviously the right comman=
d).
>
> After doing that I see that my data on a recreated /dev/md0 is there (It =
=20
> seems like it's intact). Is it safe to use this RAID1 and is my data =20
> safe? Can I now add the second block device to md0 using 'mdadm /dev/md0 =
=20
> -a /dev/sdb1' command?

Looks good. Although you should not use --force or --assume-clean,
you wouldn't have needed them, but they also don't make a difference
in the above command.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
the united nations did a poll about food. the only question they asked
was: "could you please give your honest opinion about a solution for
the shortage of food in the rest of the world?" this poll failed
because:
  - in africa they didn't know what food was....
  - in eastern-europe they didn't know what honest was....
  - in western-europe they didn't know what shortage was...
  - in china they didn't know what opinion was...
  - in the middle-east they didn't know what solution was...
  - in south-america they didn't know what please was...
  - and in the usa they didn't know what "the rest of the world" was...
=20
spamtraps: madduck.bogus@madduck.net

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH9H1dIgvIgzMMSnURAhmxAJwJ4E2TSEIChwCFHYukTSgleW4wFACcD1Ac
oWTD2wfFxoVTXu2yhVKm/ZU=
=Jp6Z
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
