Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZDNK3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZDNK3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZDNK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:29:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50418 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZDNK3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:29:44 -0400
Date: Tue, 14 Apr 2009 20:29:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lockdep: warn about lockdep disabling after kernel
 taint, fix
Message-Id: <20090414202937.b3af431f.sfr@canb.auug.org.au>
In-Reply-To: <20090414091538.GI27003@elte.hu>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
	<20090414091538.GI27003@elte.hu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Apr_2009_20_29_37_+1000_Vp=oirx6LNFRkris"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Apr_2009_20_29_37_+1000_Vp=oirx6LNFRkris
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 14 Apr 2009 11:15:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> This opened up the path for someone eventually only including=20
> asm/atomic.h from generic code and breaking the architectures that=20
> only provide it via system.h. So i've queued up the fix below - this=20
> should address the problem on Sparc and s390.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Apr_2009_20_29_37_+1000_Vp=oirx6LNFRkris
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknkZZEACgkQjjKRsyhoI8wskgCghiF0uovgeY5ZRxHxwALFHynd
d80An36LDimcBloHzJMZcsp+da0BbJF6
=4TAL
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Apr_2009_20_29_37_+1000_Vp=oirx6LNFRkris--
