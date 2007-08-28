Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbXH1Qoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbXH1Qoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXH1Qoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:44:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37502 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXH1Qon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:44:43 -0400
Date: Tue, 28 Aug 2007 09:44:40 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [PATCH] hwmon: Add power meters to Documentation/hwmon/sysfs-interface
Message-ID: <20070828164440.GL32667@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y+Z5jE7Arku/2GrR"
Content-Disposition: inline
In-Reply-To: <20070828131942.18449886@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Y+Z5jE7Arku/2GrR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Update the hwmon sysfs interface documentation to include a specification
for power meters.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/sysfs-interface |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysf=
s-interface
index b3a9e1b..da546ce 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -304,6 +304,21 @@ curr[1-*]_input	Current input value
 		Unit: milliampere
 		RO
=20
+*********
+* Power *
+*********
+
+power[1-*]_input	Current power use
+			Unit: milliWatt
+			RO
+
+power[1-*]_max_input	Historical maximum power use
+			Unit: milliWatt
+			RO
+
+power[1-*]_min_input	Historical minimum power use
+			Unit: milliWatt
+			RO
=20
 **********
 * Alarms *

--Y+Z5jE7Arku/2GrR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1FD4a6vRYYgWQuURAmRjAKCOEumX1dcUVMpbMBm7PANfM5KKfQCgjH2w
inT5ba/UK4ihIWJ/LUKYC0U=
=1aoj
-----END PGP SIGNATURE-----

--Y+Z5jE7Arku/2GrR--
