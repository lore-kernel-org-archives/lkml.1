Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYD3Gmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYD3Gmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYD3Gm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:42:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52639 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738AbYD3GmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:42:25 -0400
Date: Wed, 30 Apr 2008 16:42:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <dgc@sgi.com>
Cc: linux-next@vger.kernel.org, xfs-masters@oss.sgi.com,
       Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: xfs build failure
Message-Id: <20080430164218.9c2bfb1c.sfr@canb.auug.org.au>
In-Reply-To: <20080430063544.GA108924158@sgi.com>
References: <20080430140027.6cd83fd0.sfr@canb.auug.org.au>
	<20080430063544.GA108924158@sgi.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_16_42_18_+1000_wxn3sCaITfTuMRqX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_16_42_18_+1000_wxn3sCaITfTuMRqX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 30 Apr 2008 16:35:44 +1000 David Chinner <dgc@sgi.com> wrote:
>
> Ah, I see the problem - a CONFIG_XFS_DEBUG build includes linux/random.h
> in a debug header file. That's probably why I didn't catch it (I need to
> check the .config on my build test tree).
>=20
> I'll get it fixed properly, but in the mean time the include you've got
> there will suffice...

Could you make sure something gets sent to Linus pretty quickly as this
breaks a lot of the powerpc builds at the moment (see
http://kisskb.ellerman.id.au/kisskb/branch/3/).  Or should I do my patch
up and sent it?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_16_42_18_+1000_wxn3sCaITfTuMRqX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGBTOTgG2atn1QN8RAgP+AJ9CTYGuPxZOXJFiUc+78Ux6e4ilKQCgh6Fx
Ptbkmw6vkQIC/4iRXTZEE+s=
=J1Tr
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_16_42_18_+1000_wxn3sCaITfTuMRqX--
