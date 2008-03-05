Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbYCEXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbYCEXQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765186AbYCEXN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:13:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50105 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbYCEXN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:13:27 -0500
Date: Thu, 6 Mar 2008 10:13:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: linux-next: Tree for March 5
Message-Id: <20080306101320.80320085.sfr@canb.auug.org.au>
In-Reply-To: <20080305.145520.241264097.davem@davemloft.net>
References: <20080305204708.6834c627.sfr@canb.auug.org.au>
	<20080305.145520.241264097.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Mar_2008_10_13_20_+1100_B6jM9ZS8bTnuGYbI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2008_10_13_20_+1100_B6jM9ZS8bTnuGYbI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 05 Mar 2008 14:55:20 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Feel free to start pulling in:
>=20
> git://git.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.26.git#master

Added, thanks.

> I just did a test pull into the current linux-next.
>=20
> There was one conflict, net/tipc/socket.c, which has been converted
> from semaphores to mutexes.  It conflicts with the generic semaphores
> change, and essentially you can simply remove the generic semaphore
> modifications to this file when you build the next tree since the
> net-2.6.26 tree changes these TIPC bits to not use semaphores any
> more.
>=20
> The result builds cleanly allmodconfig on sparc64.

Thanks for testing.  I have put this tree ahead of the semaphore tree so
that the pain will fall appropriately :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2008_10_13_20_+1100_B6jM9ZS8bTnuGYbI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzykUTgG2atn1QN8RArvPAJ0XTVQ0wk5RNHYX0SndEXZOKxOOOQCfcN2Q
cPZlq1ec6KR4zQgQy3zspns=
=OPyO
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2008_10_13_20_+1100_B6jM9ZS8bTnuGYbI--
