Return-Path: <linux-kernel-owner+w=401wt.eu-S936488AbXJSTyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936488AbXJSTyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936635AbXJSTxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:53:31 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32835 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937046AbXJSTx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:53:29 -0400
Subject: Re: 2.6.23-rc8-mm2 ACPI Battery Info in /sys but not /proc/acpi
From: Zan Lynx <zlynx@acm.org>
To: Chris Bandy <cbandy@jbandy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <4718D46B.2070508@jbandy.com>
References: <4718D46B.2070508@jbandy.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nFcjmGMQ1m84vDPUxMRa"
Date: Fri, 19 Oct 2007 13:53:24 -0600
Message-Id: <1192823604.7460.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071019/1IixuP-0006Ey-76-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nFcjmGMQ1m84vDPUxMRa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-19 at 11:59 -0400, Chris Bandy wrote:
> I had this same problem, but found that it was because I turned off the
> newly deprecated CONFIG_ACPI_PROCFS.

This was the problem.  Thank you.

What confused me was that *only* the battery information seemed to be
missing.  If all the ACPI info in /proc had been missing I would have
suspected something like this right away.
--=20
Zan Lynx <zlynx@acm.org>

--=-nFcjmGMQ1m84vDPUxMRa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHGQs0G8fHaOLTWwgRAjRHAJ40RxSxm2ZHBKalW/nanCEHHpXq4QCgpPkq
+SvGt2RBtqRzCZgzeDx+MXY=
=z5zw
-----END PGP SIGNATURE-----

--=-nFcjmGMQ1m84vDPUxMRa--

