Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYC1NB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYC1NB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbYC1Mzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:47 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbYC1Mzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:44 -0400
Date: Fri, 28 Mar 2008 07:25:48 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 13/35] W1: Document add, remove, and search_count.
Message-ID: <20080328122548.GN3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1HuzLmPZrG5RH6bG"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:48 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1HuzLmPZrG5RH6bG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Documentation/w1/w1.generic 1.2
Document w1_master_add, w1_master_remove, and search_count.

Signed-off-by: David Fries <david@fries.net>
---
 Documentation/w1/w1.generic |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Documentation/w1/w1.generic b/Documentation/w1/w1.generic
index 4c6509d..98111a3 100644
--- a/Documentation/w1/w1.generic
+++ b/Documentation/w1/w1.generic
@@ -79,10 +79,12 @@ w1 master sysfs interface
 <xx-xxxxxxxxxxxxx> - a directory for a found device. The format is family-=
serial
 bus                - (standard) symlink to the w1 bus
 driver             - (standard) symlink to the w1 driver
+w1_master_add      - Manually register a slave device
 w1_master_attempts - the number of times a search was attempted
 w1_master_max_slave_count
                    - the maximum slaves that may be attached to a master
 w1_master_name     - the name of the device (w1_bus_masterX)
+w1_master_remove   - Manually remove a slave device
 w1_master_search   - the number of searches left to do, -1=3Dcontinual (de=
fault)
 w1_master_slave_count
                    - the number of slaves found
@@ -90,7 +92,13 @@ w1_master_slaves   - the names of the slaves, one per li=
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

--1HuzLmPZrG5RH6bG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OPMAI852cse6PARAuYmAJ40MzMVV14BQ3RfMb0ZdGHj1SEkTQCfWEFd
DmeXAaNqy/GbdAOd11bfY6A=
=9zmb
-----END PGP SIGNATURE-----

--1HuzLmPZrG5RH6bG--
