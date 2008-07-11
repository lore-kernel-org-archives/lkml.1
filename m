Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYGKX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYGKX1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYGKX05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:26:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45146 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYGKX04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:26:56 -0400
Date: Sat, 12 Jul 2008 09:26:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Howells <dhowells@redhat.com>,
       jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a const assignment in moxa_load_fw()
Message-Id: <20080712092647.7f379d99.sfr@canb.auug.org.au>
In-Reply-To: <20080711122056.8b36c084.akpm@linux-foundation.org>
References: <20080708154416.24850.30733.stgit@warthog.procyon.org.uk>
	<20080708171029.08db0f4d@the-village.bc.nu>
	<20080711122056.8b36c084.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__12_Jul_2008_09_26_47_+1000_ttR1D244T1D5CQcQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Jul_2008_09_26_47_+1000_ttR1D244T1D5CQcQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 11 Jul 2008 12:20:56 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Appears to already be fixed in linux-next, perhaps by this:
>=20
> commit b30a6a47716ba1a5112b44f0a3962daff961935e
> Author: Alan Cox <alan@redhat.com>
> Date:   Fri Jul 4 19:18:14 2008 +1000
>=20
>     83-tty-moxa-warning

Which became 88-tty-moxa-warning and was dropped (the individual patch)
from next-20080711 because it didn't apply.

>    =20
>     Signed-off-by: Alan Cox <alan@redhat.com>
>=20
> which, err, isn't in today's linux-next because the whole tty tree got
> accidentally dropped.  Not that this was a tty patch.

All except two patches from the ttydev tree are in
"today's" (next-20080711) linux-next tree.  (The tag is better than
saying "today" since I am in a different time zone to most of you :-))
The whole tree was dropped a few days ago but came back.

> Hopefully the patches in this tree will get title and changelog repairs
> before they go much further.  I suspect a lot of this damage was due to
> incompatibility between Alan's patch-file format and the expectations of
> Stephen's scripts.

Yeah, Alan and I need to have a conversation about that ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_Jul_2008_09_26_47_+1000_ttR1D244T1D5CQcQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh37DcACgkQjjKRsyhoI8z2iwCfXt3LdB17h6+N5Wq4dfuAhjpx
ZFQAn0MvenWVc8hg3xw4U5ZlceNSqcbG
=kKsn
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Jul_2008_09_26_47_+1000_ttR1D244T1D5CQcQ--
