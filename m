Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0BQRi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:38:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:27249 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab0BQRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:38:26 -0500
Date: Wed, 17 Feb 2010 17:38:22 +0000
From: Eric B Munson <ebmunson@us.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: perf record and multiple events
Message-ID: <20100217173822.GA4137@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

While testing perf record I found that when multiple events are specified
on the command line, i.e. perf record -e dTLB-misses -e cache-misses,
the are lumped into a single category on output from perf report.  The
same event specification gives two event categories when using perf stat.
Is this working as expected or should I see seperate entries in the report
for each event?

--=20
Eric B Munson
IBM Linux Technology Center
ebmunson@us.ibm.com


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkt8KY4ACgkQsnv9E83jkzq73gCbBpqWxfCJGOkpFxfsLRo5U9ip
OwcAoNJSr3mZu9xajVbp9LVzBN1PWRYt
=hb7Z
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
