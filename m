Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbZAQQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbZAQQlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZAQQlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:41:02 -0500
Received: from mail.klingt.org ([86.59.21.178]:50678 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZAQQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:41:00 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20090117155635.GC21604@erda.amd.com>
References: <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
	 <1231957184.13033.70.camel@thinkpad>
	 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
	 <1232010853.6541.4.camel@thinkpad>
	 <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
	 <1232067181.6134.74.camel@thinkpad>
	 <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
	 <1232199169.7016.12.camel@thinkpad> <20090117141453.GA21604@erda.amd.com>
	 <1232204963.17299.8.camel@thinkpad>  <20090117155635.GC21604@erda.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GL1Z8yuO42F1tmc1qxcr"
Date: Sat, 17 Jan 2009 17:40:36 +0100
Message-Id: <1232210436.6710.80.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Sat, 17 Jan 2009 17:40:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GL1Z8yuO42F1tmc1qxcr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> Hmm, strange. Actually 7c64ade53a6f977d73f16243865c42ceae999aea fixed
> a similiar bug, see here:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D11908
>=20
> Your patch with 2.6.28, does:
>=20
>  grep NMI /proc/interrupts
>=20
> returns exactly 1 NMI per core or some more?

that bug is similar, but it reports different numbers of NMIs for the
cores.
i get exactly one NMI per core, for each time, i start oprofile:

NMI: 0
opcontrol -s
(wait)
opcontrol --deinit
NMI: 1
opcontrol -s
(wait)
opcontrol --deinit
NMI: 2

hth, tim

--
tim@klingt.org
http://tim.klingt.org

Which is more musical, a truck passing by a factory or a truck passing
by a music school?
  John Cage

--=-GL1Z8yuO42F1tmc1qxcr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklyCgIACgkQdL+4qsZfVsu8BACgkuoPO6Az1z0cJVyJCTdp7CDj
8sgAnimS9U1434l/8Awr4jZtKBK2gfHP
=HM8A
-----END PGP SIGNATURE-----

--=-GL1Z8yuO42F1tmc1qxcr--

