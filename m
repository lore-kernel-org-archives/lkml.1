Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZJMDe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZJMDe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZJMDe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:34:26 -0400
Received: from grsecurity.net ([209.9.226.146]:54625 "EHLO grsecurity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbZJMDe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:34:26 -0400
Date: Mon, 12 Oct 2009 23:33:40 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] ia64: Don't call SAL < 3.2 for extended config space
Message-ID: <20091013033340.GA8673@grsecurity.net>
References: <20091011074531.GA12357@grsecurity.net> <4AD1AE0D.1030007@kernel.org> <4AD24766.7050205@kernel.org> <20091011213245.GC18513@grsecurity.net> <20091011231039.GB7545@parisc-linux.org> <20091012135628.GA310@grsecurity.net> <20091012142430.GE7545@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20091012142430.GE7545@parisc-linux.org>
User-Agent: Mutt/1.5.9i
From: spender@grsecurity.net (Brad Spengler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> +	} else if (sal_revision >= SAL_VERSION_CODE(3,2))

Looks like a missing ending { here ^
> +	} else if (sal_revision >= SAL_VERSION_CODE(3,2))
and here ^

I'll test it to confirm it fixes the problem.

-Brad

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFK0/UTmHm2SUJF1GoRAjlAAJ4yWDmVByCLxU3gvpmeg2neYWGqjACgh3Ow
nlIhAteyiSJAVq8aDb/6om4=
=e9tL
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
