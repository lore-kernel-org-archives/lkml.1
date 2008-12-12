Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYLLUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYLLUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYLLUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:25:19 -0500
Received: from bender.home.grueneberg.de ([82.139.255.106]:59302 "EHLO
	bender.home.grueneberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYLLUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:25:17 -0500
X-Greylist: delayed 2256 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 15:25:17 EST
Date: Fri, 12 Dec 2008 20:47:28 +0100
From: Andre Grueneberg <list.lguest@grueneberg.de>
To: lguest@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <20081212194728.GE29143@leela.home.grueneberg.de>
Mail-Followup-To: lguest@ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
X-message-flag: Please send plain text messages only. Thank you.
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: lguest, virtio_blk, id is not a head!
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

[I'm not regularly reading lkml, but I do read lguest, so please include
me in CC]
I'm using lguest and thus virtio_blk.
Lately I upgraded my host and guest from kernel 2.6.25 (Debian) to
vanilla 2.6.27.8. I have two virtual machines and in both I recognised
the same issue after a while.

After running for some hours the first guest showed the following
message on the console:
virtio_blk virtio1: id 1 is not a head!

Afterwards I was not able to log in to the guest anymore, so I had to
kill it. The kernel was still running -- ping was answered. Only the=20
block device (with / on it) seems to have went unresponsive.

A few days later the other guest "crashed" with a similar message
(different id). Another two days later, the same happened.

I do not (yet) know how to reproduce this issue, but it seems to happen
more often. I've never seen this happen with 2.6.25, which ran for ~3
months without stop.

I'm thankful for any idea how to hunt this issue. Especially I wonder
under what (practical) circumstances one can trigger the respective code
in drivers/virtio/virtio_ring.c vring_get_buf().

Thanks,
Andre

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklCv88ACgkQLPeb7q968GAb+gCgr6lDwa1zBt0bVGykHlMD8GZW
vZsAoLU4rrp/p/SlzkMlK/IbvgmohvIr
=cLXl
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
