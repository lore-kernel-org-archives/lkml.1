Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYHPIf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYHPIf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYHPIfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:35:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58927 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYHPIfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:35:44 -0400
Date: Sat, 16 Aug 2008 18:35:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alexander Viro <aviro@redhat.com>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: fs: Make linux kernel parser's match_table_t const
Message-Id: <20080816183536.47dbfae6.sfr@canb.auug.org.au>
In-Reply-To: <1218808842.20622.130.camel@quoit>
References: <1218808842.20622.130.camel@quoit>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Aug_2008_18_35_36_+1000_gByl5.2gMsmPxUq="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Aug_2008_18_35_36_+1000_gByl5.2gMsmPxUq=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Fri, 15 Aug 2008 15:00:42 +0100 Steven Whitehouse <swhiteho@redhat.com> =
wrote:
>
> Unlike the previous version, I've put the "const" by the individual
> variable declarations, all aside from the nfsroot one that is
> which was the cause of the problems. That is marked as __initconst
> instead.

A much better approach - hiding the "const" in the typedef was always a
bit strange.

> Is this trivial enough for the trivial tree, or is there a better
> place for it, VFS tree, or direct into linux-next for example?

linux-next currently has no easy way to include single patches like
this.  An alternative approach would be to ask Linus to take just the
changes to match_token() into his tree now (as they are clearly correct
and don't adversely affect any other code) and then send all the other
bits to each of the maintainers.  That way we avoid possible conflicts in
linux-next over the following months and during the next merge window.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Aug_2008_18_35_36_+1000_gByl5.2gMsmPxUq=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkimkVgACgkQjjKRsyhoI8ycXgCfa3oAA9rfhcc7HTKWjZ3xH6U8
cw8AnA0OmYE074BHRzd12+SY1GANuJNk
=szI1
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Aug_2008_18_35_36_+1000_gByl5.2gMsmPxUq=--
