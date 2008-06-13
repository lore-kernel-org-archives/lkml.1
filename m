Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbYFMBJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbYFMBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYFMBJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:09:52 -0400
Received: from [194.117.236.238] ([194.117.236.238]:41429 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbYFMBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:09:51 -0400
Date: Fri, 13 Jun 2008 04:09:11 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: [PATCH 0/3] (resubmit) relay interface bugfixes and early logging
 support
Message-ID: <20080613040911.7558618c@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aO748ZJ54GdFJX1uva/fZ_U";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aO748ZJ54GdFJX1uva/fZ_U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Thanks to Andrea Righi for pointing out an error in patch number 2. I
resubmitted the whole patch series because there were some problems
reported by scripts/checkpatch.pl.

I apologize for any inconvenience caused.

Eduard - Gabriel Munteanu (3):
  relay: Fix 4 off-by-one errors occuring when writing to a CPU buffer.
  relay: Fix race condition which occurs when reading across CPUs.
  relay: Add buffer-only channels; useful for early logging.

 Documentation/filesystems/relay.txt |   11 +++
 include/linux/relay.h               |   19 ++++--
 kernel/relay.c                      |  136 ++++++++++++++++++++++++++-----=
----
 3 files changed, 127 insertions(+), 39 deletions(-)

--Sig_/aO748ZJ54GdFJX1uva/fZ_U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUBSFHIvNxcOkuRpXptAQIt9g//bWir1jR/p5mXYWc2Nz1h6aLUReFfQFoy
imu/kx0wKm/HBrACqgOmJYc0rVkDhiSjRsCGOsfYCqEn1tWORVV+XMdasqvjEBlH
eMwEeBtO6in+E8eIVXVniSeC2ns7ivuh6xbty8xaTuAVeUvYhPS538Nb/v4C18n/
WQOLKIf4Ds1XCron17eLwPO5xFGquABZb6E8hsAC+VWvsfGI4lvtuh//SZTs9Vrr
Ga2Lfmap1H0UaWzLUsMmbCmrXwjXCbtQjnlao/VED/eXlW7MlddrXQn0gNgt6Zxf
C88RjggvWEWH/fr5m5+SluP+BCZHWeydM2JSKhJsHOssX7WAmGrR5ry/EqP7+FoI
6iG98VdgZ74uOkp2J+gTgVnQzulog0a0a9vIh94L77xeFVVsprD9ky1LFek7wx+t
oR6CorX6XDA7kbFp5QJm3lDcrs4Q/ep8HDmmIbsmFhZYVk+/U0LlvKGo+a5YucqW
qjMnVlXZsB0GNDGyqvgFbf5jjqSv17ucz3yzPU6KNYGJtp7P38lNtL57WPM/wP5A
BnpyADFFf3w3k8DQOvR5WCGbMAh91w1onspSPL6LB35IWBG4O1gRNWkq6knJsaho
QCENrHSfqan8qRMEgnB+UdTWSLuKEwfgEME3bF3hz04brWE9qGF7ztV8XLd0Du8q
jnILqLouyW4=
=2KFS
-----END PGP SIGNATURE-----

--Sig_/aO748ZJ54GdFJX1uva/fZ_U--
