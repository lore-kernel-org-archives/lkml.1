Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZFJIpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZFJIpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZFJIo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:44:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44228 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbZFJIo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:44:58 -0400
Date: Wed, 10 Jun 2009 18:44:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-Id: <20090610184455.c06375d2.sfr@canb.auug.org.au>
In-Reply-To: <20090610083139.GA25538@infradead.org>
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
	<20090610083139.GA25538@infradead.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_18_44_55_+1000_Pb82UChjR=k7+blo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_18_44_55_+1000_Pb82UChjR=k7+blo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, 10 Jun 2009 04:31:39 -0400 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> On Wed, Jun 10, 2009 at 06:00:58PM +1000, Stephen Rothwell wrote:
> > The machines are PowerPC64 (so big endian).  It looks to me like we use
> > bitops on i_state - don't our bitops only apply to unsigned longs?
>=20
> Yes, bitops need unsigned long.  And on most plaforms should give you
> warnings when using them on the wrong type.

In this case the "word" is being passed through wait_on_bit which takes a
"void *", so we lose the type information.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_18_44_55_+1000_Pb82UChjR=k7+blo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovcocACgkQjjKRsyhoI8ya/ACfSEshCmEPvlT0huDEQPfkBmvt
b8IAnR/RRJoT1Tl8xfloy4LNZIyyPTGi
=8ANQ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_18_44_55_+1000_Pb82UChjR=k7+blo--
