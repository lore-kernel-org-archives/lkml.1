Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZABLEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZABLEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbZABLEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:04:44 -0500
Received: from mail.klingt.org ([86.59.21.178]:47646 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbZABLEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:04:43 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>, venkatesh.pallipadi@intel.com
In-Reply-To: <49544497.9020900@linux.intel.com>
References: <1229869416.6911.1.camel@thinkpad>
	 <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fHlQqzEXidjHT9CjACRz"
Date: Fri, 02 Jan 2009 12:04:17 +0100
Message-Id: <1230894257.6072.10.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Fri, 02 Jan 2009 12:04:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fHlQqzEXidjHT9CjACRz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-26 at 03:42 +0100, Andi Kleen wrote:
> Tim Blechmann wrote:
> >> i am experiencing an issue, similar to the one reported in
> >> http://lkml.org/lkml/2008/10/30/319.
> >=20
> > bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> > (oprofile: Implement Intel architectural perfmon support) caused the
> > problem.=20
> > oddly, the newly introduced api is not used, since the model struct is
> > set during the ppro_init call ...
>=20
> We're still investigating the problem. Thanks for the report.

btw, this issue still exists in tip/oprofile ... not sure, whether this
may be related, but i am running the machine in 64-bit mode ...

best, tim

--
tim@klingt.org
http://tim.klingt.org

I had nothing to offer anybody except my own confusion
  Jack Kerouac

--=-fHlQqzEXidjHT9CjACRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkld9K8ACgkQdL+4qsZfVsublQCZAeqMkLThTM28t4RZzvpanfuP
UQkAn0WGhXU2bMLB5nrqtD0Y/GBfvkzw
=rWPr
-----END PGP SIGNATURE-----

--=-fHlQqzEXidjHT9CjACRz--

