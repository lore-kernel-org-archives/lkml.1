Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYLIVrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYLIVrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYLIVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:47:27 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:44418 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597AbYLIVr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:47:26 -0500
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.33,743,1220220000";   d="scan'208";a="93224134"
Date: Tue, 09 Dec 2008 22:47:21 +0100
From: markus reichelt <ml@mareichelt.de>
To: linux-kernel@vger.kernel.org
Subject: Sanitizing Pipe Buffers
Message-id: <20081209214721.GB3738@tatooine.rebelbase.local>
Mail-followup-to: linux-kernel@vger.kernel.org
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=IS0zKkzwUGydFO0o
Content-disposition: inline
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

who maintains that pipe buffer magic in 2.6?=20

Reason I'm asking: The kernel 2.4 branch does not sanitize pipe
buffers, but there's a trivial patch to achieve this [1]

I'd like to have the option to sanitize pipe buffers in 2.6.x kernels
too, so I'm looking for a person to talk to. From what I heard,
in kernel 2.6 branch pipe magic works differently. To what extend
exactly? Or are pipe buffers already sanitized in the 2.6 kernel
branch? (I doubt that)

In light of the cold-boot attack[2] I'd like to have pipe buffers
sanitized. So, how do I achieve this? Any hints?


[1] http://mail.nl.linux.org/linux-crypto/2008-06/msg00004.html
[2] http://citp.princeton.edu/memory/

--=20
left blank, right bald

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk+52kACgkQLMyTO8Kj/uSrHACcDHGqL8thwCcF38zH02QPESjy
p+wAn2zCt175GAWkLyrrhQA1yeDHCML8
=tbvq
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
