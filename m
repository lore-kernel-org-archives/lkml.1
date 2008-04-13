Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYDMXQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYDMXQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYDMXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:15:21 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49157 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYDMXPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:15:18 -0400
Date: Sun, 13 Apr 2008 18:15:17 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/33 replaces 13/35] W1: Document add, remove, search_count, and pullup.
Message-ID: <20080413231517.GE15213@spacedout.fries.net>
References: <20080413225632.GA14058@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <20080413225632.GA14058@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 18:15:17 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This is an update to the previous set of patches, don't merge them
yet.  Some of the context was messed up and I don't expect patch to
apply the updates with the previous set cleanly.  I'll resubmit the
entire set if these updates look good.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Documentation/w1/w1.generic 1.2 1.3
Document w1_master_add, w1_master_remove, search_count, and pullup.

Signed-off-by: David Fries <david@fries.net>
---
 Documentation/w1/w1.generic |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/w1/w1.generic b/Documentation/w1/w1.generic
index 4c6509d..e3333ee 100644
--- a/Documentation/w1/w1.generic
+++ b/Documentation/w1/w1.generic
@@ -79,10 +79,13 @@ w1 master sysfs interface
 <xx-xxxxxxxxxxxxx> - a directory for a found device. The format is family-=
serial
 bus                - (standard) symlink to the w1 bus
 driver             - (standard) symlink to the w1 driver
+w1_master_add      - Manually register a slave device
 w1_master_attempts - the number of times a search was attempted
 w1_master_max_slave_count
                    - the maximum slaves that may be attached to a master
 w1_master_name     - the name of the device (w1_bus_masterX)
+w1_master_pullup   - 5V strong pullup 0 enabled, 1 disabled
+w1_master_remove   - Manually remove a slave device
 w1_master_search   - the number of searches left to do, -1=3Dcontinual (de=
fault)
 w1_master_slave_count
                    - the number of slaves found
@@ -90,7 +93,13 @@ w1_master_slaves   - the names of the slaves, one per li=
ne
 w1_master_timeout  - the delay in seconds between searches
=20
 If you have a w1 bus that never changes (you don't add or remove devices),
-you can set w1_master_search to a positive value to disable searches.
+you can set the module parameter search_count to a small positive number
+for an initially small number of bus searches.  Alternatively it could be
+set to zero, then manually add the slave device serial numbers by
+w1_master_add device file.  The w1_master_add and w1_master_remove files
+generally only make sense when searching is disabled, as a search will
+redetect manually removed devices that are present and timeout manually
+added devices that aren't on the bus.
=20
=20
 w1 slave sysfs interface
--=20
1.4.4.4

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIApQFAI852cse6PARAi0yAKDTVb66VA4HoIl4SJErvNMvA66YYgCgjpjE
4mmofsaFSExlX22yvqcRhi4=
=VDn1
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
