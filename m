Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZDGDOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZDGDOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZDGDOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:14:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZDGDOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:14:32 -0400
Date: Tue, 7 Apr 2009 13:14:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       kees@ubuntu.com
Subject: Re: [PATCH next] sysctl: fix build breakage
Message-Id: <20090407131409.fbc4926f.sfr@canb.auug.org.au>
In-Reply-To: <20090406171112.dcfd1dc3.sfr@canb.auug.org.au>
References: <20090406070152.GA29032@orion>
	<20090406171112.dcfd1dc3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Apr_2009_13_14_09_+1000_pAaO.SrU/DIHzX=="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Apr_2009_13_14_09_+1000_pAaO.SrU/DIHzX==
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Apr 2009 17:11:12 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 6 Apr 2009 11:01:52 +0400 Alexander Beregalov <a.beregalov@gmail.=
com> wrote:
> >
> > Fix this build error when MODULES is not set:
> > kernel/sysctl.c:545: error: 'one' undeclared here
>=20
> Thanks for this.
>=20
> This is a result of the automated merge of the security-testing tree into
> the linux-next tree getting it wrong (but it is unreasonable to expect it
> to get it right).  I will fix this up tomorrow if it is still necessary.

One of the changes that caused this has been removed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Apr_2009_13_14_09_+1000_pAaO.SrU/DIHzX==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknaxQEACgkQjjKRsyhoI8xaxQCgsazeOYrL/T8QnSreYEnCnc/H
gWQAoJOY3ssR1yJo94Sq4whynQU/p8Pe
=h14w
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Apr_2009_13_14_09_+1000_pAaO.SrU/DIHzX==--
