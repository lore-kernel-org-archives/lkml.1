Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXJ3UZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXJ3UZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759284AbXJ3UZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:25:01 -0400
Received: from mx38.mail.ru ([194.67.23.16]:64884 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbXJ3UY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:24:59 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-acpi@vger.kernel.org
Subject: [2.6.24-rc1 regression] AC adapter state does not change after resume
Date: Tue, 30 Oct 2007 23:24:51 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1546644.vGhVvDxAE7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710302324.52822.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1546644.vGhVvDxAE7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I suspect new ACPI AC adapter code but have to add some printk's to be sure.

To reproduce - plug in AC cord, suspend, unplug, resume - kpowersave and sy=
sfs=20
still show AC adapter online. Or other way round.

=2Dandrey

--nextPart1546644.vGhVvDxAE7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ5MUR6LMutpd94wRAueKAJ9LKmBPLr7UYvtE47hvS5EYnOBQ/gCgicmI
AoS/lPf2FWK0/mPq6rXacnc=
=DKAX
-----END PGP SIGNATURE-----

--nextPart1546644.vGhVvDxAE7--
