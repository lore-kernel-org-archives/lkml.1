Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYGAAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYGAAej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYGAAe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:34:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbYGAAe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:34:27 -0400
Date: Tue, 1 Jul 2008 10:34:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       akpm <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH -next] fork and exit: need to include iocontext.h
Message-Id: <20080701103417.c0c09538.sfr@canb.auug.org.au>
In-Reply-To: <20080630183337.GD32211@elte.hu>
References: <20080630105458.7c95e195.randy.dunlap@oracle.com>
	<20080630180506.GC23739@elte.hu>
	<20080630112222.f103e477.randy.dunlap@oracle.com>
	<20080630183337.GD32211@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jul_2008_10_34_17_+1000_BfUla51nsbwj7=OD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jul_2008_10_34_17_+1000_BfUla51nsbwj7=OD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jun 2008 20:33:37 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> normally there's an easy way to find out the source commit of build=20
> failures. Try something like:
>=20
>  git-bisect reset
>  git-bisect start
>  git-bisect good v2.6.26-rc8

More generally "git-bisect good linux-next/stable" - the stable branch is
just where I started on Linus' tree and that is always good :-)

>  git-bisect bad linux-next/master
>  git-bisect run make kernel/fork.o
>=20
> ... this should lead you to the commit that broke the build=20
> automatically. (as long as everyone keeps make oldconfig compatibility)

Nice, I must try this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Jul_2008_10_34_17_+1000_BfUla51nsbwj7=OD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhpe4kACgkQjjKRsyhoI8x0UQCgh6yyFJrG3uD6w1Ec0cWpGhe9
uloAnR3CkOaFWWLZWuqviP26qV0/4ASV
=g2xi
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jul_2008_10_34_17_+1000_BfUla51nsbwj7=OD--
