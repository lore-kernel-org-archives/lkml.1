Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbXFUVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbXFUVBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXFUVBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:01:07 -0400
Received: from mxfep04.bredband.com ([195.54.107.79]:65528 "EHLO
	mxfep04.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbXFUVBF (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:01:05 -0400
Subject: [BUG] Sky2 driver in 2.6.22-rc5-git1-cfs-v17
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Linux-kernel@vger.kernel.org
Cc: shemminger@linux-foundation.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mCEI2KgbiS9LIV6qzobO"
Date: Thu, 21 Jun 2007 22:51:32 +0200
Message-Id: <1182459092.7032.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mCEI2KgbiS9LIV6qzobO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20

recently have started to see this in my dmesg:

NETDEV WATCHDOG: eth0: transmit timed out
sky2 eth0: tx timeout
sky2 eth0: transmit ring 449 .. 408 report=3D449 done=3D449
sky2 eth0: disabling interface
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx

I'm not using MSI since it seems to have caused problems in the past.

I run with a 9k mtu

sky2 eth0: transmit ring 18 .. 489 report=3D18 done=3D18
---- I assume ring max is 512 (ie 1-512) since:
	Ring parameters for eth0:
	Current hardware settings:
	RX:             168
	RX Mini:        0
	RX Jumbo:       0
	TX:             511
=09
	And 489 + 41 - 18 =3D 512

sky2 eth0: transmit ring 197 .. 156 report=3D197 done=3D197
sky2 eth0: transmit ring 480 .. 439 report=3D480 done=3D480
sky2 eth0: transmit ring 413 .. 372 report=3D413 done=3D413
sky2 eth0: transmit ring 320 .. 279 report=3D320 done=3D320

Else, they are all off by 41.

Is this a known bug?
Comments? ideas?

Offload parameters for eth0:
rx-checksumming: on
tx-checksumming: on
scatter-gather: on
tcp segmentation offload: on
udp fragmentation offload: off

--=20
Ian Kumlien <pomac (a) vapor ! com> -- http://pomac.netswarm.net

--=-mCEI2KgbiS9LIV6qzobO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBGeuTO7F3Euyc51N8RAmEmAKCY5W48RpurSDX3bH9aYLwR1KRn9wCgoaAI
m+UqRYRJtaicAm0H+XXwAWE=
=g0kC
-----END PGP SIGNATURE-----

--=-mCEI2KgbiS9LIV6qzobO--
