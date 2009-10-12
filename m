Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZJLN5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZJLN5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbZJLN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:57:11 -0400
Received: from place.holder ([209.9.226.146]:50746 "EHLO grsecurity.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbZJLN5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:57:10 -0400
Date: Mon, 12 Oct 2009 09:56:28 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] pci: fix crash about old IA64 about pci_cfg_space_size
Message-ID: <20091012135628.GA310@grsecurity.net>
References: <20091011074531.GA12357@grsecurity.net> <4AD1AE0D.1030007@kernel.org> <4AD24766.7050205@kernel.org> <20091011213245.GC18513@grsecurity.net> <20091011231039.GB7545@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20091011231039.GB7545@parisc-linux.org>
User-Agent: Mutt/1.5.9i
From: spender@grsecurity.net (Brad Spengler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> So how about we go back to adding that check ... this does require that
> SGI's 750 machine reports its SAL revision correctly.  Could you send
> the dmesg?

The dmesg of the working kernel:
http://grsecurity.net/~spender/dmesg.txt
The output of lspci -vvxxxx:
http://grsecurity.net/~spender/lspci1.txt
The output of lspci -tvnn:
http://grsecurity.net/~spender/lspci2.txt

I don't have a serial console hooked up to the machine, and I'm not able=20
to scroll up/down after the panic, so I only have the following picture=20
=66rom the crash.  I modified the code that spews out registers on a panic=
=20
so that the context of the panic could be seen.  The stack trace didn't=20
show anything useful, only repeats of an address similar to IP (for=20
which no symbols exist).
http://img132.yfrog.com/i/img1457u.jpg/

-Brad

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFK0zWLmHm2SUJF1GoRAhKZAJ9MkeYGVOUbgQv+aXeYxSJM2dF5/ACdFYec
YBBCnarE0iOlb98vFXrPUao=
=TfXW
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
