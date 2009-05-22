Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZEVAus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZEVAus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZEVAuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:50:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47624 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZEVAuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:50:39 -0400
Date: Fri, 22 May 2009 10:50:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: kill-the-bkl/reiserfs: request for linux-next inclusion
Message-Id: <20090522105033.1426d409.sfr@canb.auug.org.au>
In-Reply-To: <c62985530905201640j4a550b5bi7673e5a9f21029ce@mail.gmail.com>
References: <c62985530905201640j4a550b5bi7673e5a9f21029ce@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_May_2009_10_50_33_+1000_etMAzKJ0zwsHxxJi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_May_2009_10_50_33_+1000_etMAzKJ0zwsHxxJi
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fr=C3=A9d=C3=A9ric,

On Thu, 21 May 2009 01:40:57 +0200 Fr=C3=A9d=C3=A9ric Weisbecker <fweisbec@=
gmail.com> wrote:
>
> I guess Al is traveling or something.
>=20
> Until it finds its way to the VFS tree, it would be nice if this
> reiserfs bkl removal tree could be included in linux-next
> for testing.
> Could you please include it ?
>=20
> You can pull from:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> reiserfs/kill-bkl-rc6

I have included this tree from today.

What I tell everyone: all patches/commits in the tree/series must
have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_May_2009_10_50_33_+1000_etMAzKJ0zwsHxxJi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoV9tkACgkQjjKRsyhoI8xprACaApKle8g2Mj7PunYPOAK4NueY
UCUAoIdW6Er9FhjAp6sRO6YDtydxDqTQ
=KDll
-----END PGP SIGNATURE-----

--Signature=_Fri__22_May_2009_10_50_33_+1000_etMAzKJ0zwsHxxJi--
