Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbZAQPKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbZAQPKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbZAQPKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:10:02 -0500
Received: from mail.klingt.org ([86.59.21.178]:54958 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbZAQPKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:10:01 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20090117141453.GA21604@erda.amd.com>
References: <49544497.9020900@linux.intel.com>
	 <1230894257.6072.10.camel@thinkpad>
	 <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
	 <1231957184.13033.70.camel@thinkpad>
	 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
	 <1232010853.6541.4.camel@thinkpad>
	 <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
	 <1232067181.6134.74.camel@thinkpad>
	 <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
	 <1232199169.7016.12.camel@thinkpad>  <20090117141453.GA21604@erda.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oYgguk9sA5TtDg5pAuew"
Date: Sat, 17 Jan 2009 16:09:23 +0100
Message-Id: <1232204963.17299.8.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Sat, 17 Jan 2009 16:09:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oYgguk9sA5TtDg5pAuew
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > however, trying to apply this patch to 2.6.28, the behavior is the same
> > as before (one NMI) ... so possibly, it is a combination of two bugs,
> > with similar symptoms ...=20
>=20
> Tim, could you revert 7c64ade53a6f977d73f16243865c42ceae999aea too?
>=20
> If this not helps, last chance is
> 59512900baab03c5629f2ff5efad1d5d4e682ece, but this seems to be save.

i tried to revert both commits, however the behavior doesn't seem to
change. will try to apply the working patch to the child commits, maybe
i can find something interesting ...

best, tim

btw, i am not very familiar with kernel programming, but is it safe to
have `static u64 *reset_value' uninitialized, or should it be
initialized to NULL?

--
tim@klingt.org
http://tim.klingt.org

I must say I find television very educational. The minute somebody
turns it on, I go to the library and read a good book.
  Groucho Marx

--=-oYgguk9sA5TtDg5pAuew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklx9KEACgkQdL+4qsZfVssvSQCfWhPXN/r2yjuLidoGAT2U3L1J
Mg8AmgKHD6+M/XFGA3aAY/ex6X8Vo3pt
=cxS4
-----END PGP SIGNATURE-----

--=-oYgguk9sA5TtDg5pAuew--

