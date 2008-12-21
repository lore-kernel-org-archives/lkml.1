Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYLUVXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYLUVXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYLUVXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:23:22 -0500
Received: from mail.klingt.org ([86.59.21.178]:48390 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLUVXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:23:21 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Robert Richter <robert.richter@amd.com>
In-Reply-To: <1229869416.6911.1.camel@thinkpad>
References: <1229869416.6911.1.camel@thinkpad>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+8Gz6cDv2B3eWATG6SnH"
Date: Sun, 21 Dec 2008 22:23:05 +0100
Message-Id: <1229894585.6898.6.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Sun, 21 Dec 2008 22:23:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+8Gz6cDv2B3eWATG6SnH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> i am experiencing an issue, similar to the one reported in
> http://lkml.org/lkml/2008/10/30/319.

bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
(oprofile: Implement Intel architectural perfmon support) caused the
problem.=20
oddly, the newly introduced api is not used, since the model struct is
set during the ppro_init call ...

best, tim

--
tim@klingt.org
http://tim.klingt.org

Desperation is the raw material of drastic change. Only those who can
leave behind everything they have ever believed in can hope to escape.
  William S. Burroughs

--=-+8Gz6cDv2B3eWATG6SnH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklOs7UACgkQFz+XezW6HD6bpQCfau4oKjrqtb1ZkiTD+Azukq/H
gscAn298LsjFkXPXJ/ngSJrrHiS5gCIC
=Sne7
-----END PGP SIGNATURE-----

--=-+8Gz6cDv2B3eWATG6SnH--

