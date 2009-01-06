Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZAFSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZAFSt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZAFStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:49:13 -0500
Received: from attic.omnifarious.org ([216.254.16.17]:57353 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZAFStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:49:12 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 13:49:12 EST
Date: Tue, 6 Jan 2009 10:42:05 -0800
From: Eric Hopper <hopper@omnifarious.org>
To: linux-kernel@vger.kernel.org
Subject: nosync, an idea for general filesystem mount flag
Message-ID: <20090106184205.GC15454@omnifarious.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Maybe somebody has thought of this before.  But I think it would be
useful to have a mount flag telling the filesystem layer that a certain
filesystem never ever needs to be synced, even when the 'sync' system
call is called.

My /tmp, for example, is reformatted on each and every boot.  There is
no reason for anything written to /tmp to ever hit the disk.  The only
reason is to make room for something else in memory.

I think this could potentially help out notebooks that only had solid
state drives.

Anyway, just a random thought,
--=20
I am not an LKML member, so please include me in the 'To' or 'Cc' field
if you want me to see your message.  -- Eric Hopper (hopper ^at^
omnifarious ^dot^ ^o^ ^r^ ^g^)

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJY6X9jtsvlOwvazYRAq5hAKCmMQMj0SELT4uCo9EeHjGGy+CjpgCfYSJl
yU7wlVrePu7IHuEnZGnPywI=
=8/63
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
