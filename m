Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbZHEGkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbZHEGkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZHEGkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:40:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56820 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbZHEGko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:40:44 -0400
Date: Wed, 5 Aug 2009 16:40:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Rebasing the edac-amd tree (Was: Re: linux-next: manual merge of
 the edac-amd tree with Linus' tree)
Message-Id: <20090805164032.3cf9d95a.sfr@canb.auug.org.au>
In-Reply-To: <20090805062215.GA7732@liondog.tnic>
References: <20090805150933.103de233.sfr@canb.auug.org.au>
	<20090805062215.GA7732@liondog.tnic>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Aug_2009_16_40_32_+1000_P5l6ESaVPS6awTja"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Aug_2009_16_40_32_+1000_P5l6ESaVPS6awTja
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Wed, 5 Aug 2009 08:22:15 +0200 Borislav Petkov <petkovbb@googlemail.com>=
 wrote:
>
> thanks and yes, you're right. The former patch is less intrusive
> and we opted for that one since it is really late in the -rc cycle
> but the latter cleans up stuff so that code flow becomes much more
> understandable. I'll rediff later and sorry for the inconvenience.

As an alternative to rebasing, you could merge Linus' current tree into
yours and do the merge fixup there.  This is not particularly necessary,
as the fixup is fairly simple.  Though you may want to do that sometime
before you ask Linus to merge your tree.

> By the way, I see that you're merging edac-amd before tip and I'm going
> to need to rebase my tree against tip in the next couple of days since
> it depends on a bunch of stuff in it, so could you please switch the
> merge order of the two trees so that edac-amd goes after tip?

Again, instead of rebasing, you could just merge in the branches from tip
that you depend on. You need to make sure that you only depend on stable
(i.e. non rebasing) branches in the tip tree, not on the branch
(auto-latest) that is actually merged into linux-next.  Please discuss
this with Ingo.

I will move the edac-amd tree to after the tip tree tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Aug_2009_16_40_32_+1000_P5l6ESaVPS6awTja
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp5KWAACgkQjjKRsyhoI8wH5ACggC+i84UNZLf39BaqWkYdRKys
CjMAnjSDDInHj0Fq2x2DO2TGrYZybvBT
=tlL+
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Aug_2009_16_40_32_+1000_P5l6ESaVPS6awTja--
