Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbXF0Kym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbXF0Kym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXF0Kyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:54:35 -0400
Received: from systemlinux.org ([83.151.29.59]:42923 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbXF0Kye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:54:34 -0400
X-Greylist: delayed 2173 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 06:54:34 EDT
Date: Wed, 27 Jun 2007 12:16:08 +0200
From: Andre Noll <maan@systemlinux.org>
To: mchan@broadcom.com
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: 2.6.21.x kernel panic (tg3 and nfs related)
Message-ID: <20070627101608.GQ22589@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eBTWNsZZiigckDWV"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--eBTWNsZZiigckDWV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

Our nfs server recently paniced under heavy nfs load. The backtrace
indicates that this might be a problem with the tigon3 network driver
which drives the onboard chips of the machine.

The first crash under 2.6.21.1 happened after about 4 days of uptime,=20
2.6.21.5 already crashed after 15 Minutes.

Screenshots of the resulting kernel panics are available at

	http://www.systemlinux.org/~maan/shots/huangho-crash-2.6.21.1.png
and
	http://www.systemlinux.org/~maan/shots/huangho-crash-2.6.21.5.png

We're now running 2.6.18.6 again which happens to be rock solid for our
workload. However, this kernel now spits out zillons of messages like

	[55122.674290] RPC: bad TCP reclen 0x00010094 (large)

I'm sure it didn't do that half a year ago when it was running for
several months. The 2.6.21.x kernels did not print these messages
either, but from what I understand this is due to a patch which went
in somewhere between 2.6.18 and 2.6.21 and which just ratelimited
the message.

So something weird seems to be going on in our network and this might
well be related to the 2.6.21.x crashes we are seeing.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--eBTWNsZZiigckDWV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGgjjoWto1QDEAkw8RAvaKAJ9zSErbii7/q3BWzxVrKbXDXbP5WQCfRO3a
pBdoip/KNTMfzhUiCGEHm+s=
=Uu70
-----END PGP SIGNATURE-----

--eBTWNsZZiigckDWV--
