Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXJ3Uz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXJ3Uz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXJ3Uzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:55:48 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:56433 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752446AbXJ3Uzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:55:47 -0400
Date: Tue, 30 Oct 2007 21:55:25 +0100
From: Kristof Provost <Kristof@provost-engineering.be>
To: Oliv?r Pint?r <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: compile error in 2.6.24-rc1-git6 HEAD is on
	ea45d15394c57cb214aef8e6d40976c128995d43
Message-ID: <20071030205525.GK32270@berith>
References: <6101e8c40710301344s5061235ej6a8b5558ae93b981@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <6101e8c40710301344s5061235ej6a8b5558ae93b981@mail.gmail.com>
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Scanned: 2.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2007-10-30 21:44:18 (+0100), Oliv?r Pint?r <oliver.pntr@gmail.com> wrote:
>   CHECK   include/linux/tipc_config.h
> /home/oliver/develop/kernel/v2.6.24-git1-git6+/usr/include/linux/tipc_con=
fig.h
> requires linux/string.h, which does not exist in exported headers
> make[3]: *** [/home/oliver/develop/kernel/v2.6.24-git1-git6+/usr/include/=
linux/.check.tipc_config.h]
> Error 1
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2
It was broken in commit 502ef38da15d817f8e67acefc12dc2212f7f8aa1
Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3D9260 for more
details.

Kristof=20

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHJ5o9UEZ9DhGwDugRAlOeAJsEoSvIotksn35hFbghTFKeurZtXACgkeR4
ok1PjK0AraoEd8JDHhMahok=
=y0iw
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
