Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXJaEei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXJaEei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJaEe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:34:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55536 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbXJaEe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:34:27 -0400
Date: Wed, 31 Oct 2007 15:34:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_key: suppress a warning for 64k pages.
Message-Id: <20071031153422.44f864e8.sfr@canb.auug.org.au>
In-Reply-To: <20071030.210846.215166155.davem@davemloft.net>
References: <20071031145954.fe106f73.sfr@canb.auug.org.au>
	<20071030.210846.215166155.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Oct_2007_15_34_22_+1100_lJyi_Hp4mHRoTj/n"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Oct_2007_15_34_22_+1100_lJyi_Hp4mHRoTj/n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Oct 2007 21:08:46 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> I'm not so sure ifdef'ing things up all over the place is the way to
> solve this.  It makes the code ultra ugly.

I agree.

> I think we should retain the check, but modify it so that GCC knows we
> understand that it's OK if it is always false.  Perhaps a simple (u32)
> cast on the left branch of the comparison is sufficient?

Unfortunately, that does not suppress the warning (gcc is getting too
smart :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Oct_2007_15_34_22_+1100_lJyi_Hp4mHRoTj/n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHKAXTTgG2atn1QN8RAl6uAKCbPK8T9c19p0gt8G87cHdTzbms3gCgmnVQ
keMMWIcxb2zk01vSvB74B0U=
=gOq/
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Oct_2007_15_34_22_+1100_lJyi_Hp4mHRoTj/n--
