Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbZKXLLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbZKXLLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbZKXLLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:11:31 -0500
Received: from mail.klingt.org ([86.59.21.178]:33175 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808AbZKXLK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:10:57 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 06:10:50 EST
Message-ID: <4B0BBB83.2020604@klingt.org>
Date: Tue, 24 Nov 2009 11:54:59 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] branch hint tweaks
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA4D7F7211499A3D262AE343"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 11:58:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA4D7F7211499A3D262AE343
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi all,

doing some branch hint profiling of 2.6.31 on my nehalem machine showed
a few
incorrect branch hints.
these patches remove or change the branch hints

Tim Blechmann (5):
  process_64: remove branch hint
  sched.c: change branch hint
  slab.c: remove branch hint
  sched_fair.c: remove branch hint
  workqueue.c: remove branch hint

 arch/x86/kernel/process_64.c |    4 ++--
 kernel/sched.c               |    4 ++--
 kernel/sched_fair.c          |    2 +-
 kernel/workqueue.c           |    2 +-
 mm/slab.c                    |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)



--------------enigBA4D7F7211499A3D262AE343
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLu4MACgkQdL+4qsZfVssQ2gCfV5Y0yFoMHrdqmiA9snUMlPG2
pjUAoJW2t2vfVruy01X1TfD3TVcHGJgd
=KRhg
-----END PGP SIGNATURE-----

--------------enigBA4D7F7211499A3D262AE343--
