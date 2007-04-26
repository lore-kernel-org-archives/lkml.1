Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXDZPnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXDZPnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDZPnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:43:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXDZPnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:43:50 -0400
Date: Thu, 26 Apr 2007 17:43:48 +0200
From: Bernhard Walle <bwalle@suse.de>
To: vgoyal@in.ibm.com
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070426154348.GA20350@suse.de>
Mail-Followup-To: vgoyal@in.ibm.com,
	linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20070426082405.67a0fdd2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Andrew Morton <akpm@linux-foundation.org> [2007-04-26 17:24]:
>=20
> hm.  I'd be suspecting
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/=
2.6.21-rc7-mm2/broken-out/add-irqf_irqpoll-flag-common-code.patch
> and
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/=
2.6.21-rc7-mm2/broken-out/add-irqf_irqpoll-flag-on-x86_64.patch

I aggree that it's likely that the patches cause the problem. However,
Vivek, could you try without the patches if the problem is really in
theses patches?


Thanks,
   Bernhard
--=20
SUSE LINUX Products GmbH          Tel. +49 (911) 74053-0
Maxfeldstr. 5                     GF: Markus Rex
90409 N=FCrnberg, Germany           HRB 16746 (AG N=FCrnberg)
OpenPGP DDAF6454: F61F 34CC 09CA FB82 C9F6  BA4B 8865 3696 DDAF 6454

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGMMi0iGU2lt2vZFQRAuJ9AJ0ZUCBKQ38MRDs50U7eSzjR7KEtFACfTvB6
j3wSZ6NycLT1QLsV5MRS+rY=
=BZj7
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
