Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813Ab0ASEUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0ASEUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 23:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260Ab0ASEUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 23:20:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37233 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0ASEUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 23:20:05 -0500
Date: Tue, 19 Jan 2010 15:19:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: merge fixups relative to the vfs tree
Message-Id: <20100119151955.1d07aa71.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.1001181512340.1759@cobra.newdream.net>
References: <20100118182852.9820b770.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.1001181512340.1759@cobra.newdream.net>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Jan_2010_15_19_55_+1100_BtsVC_PDsHOnqjPE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jan_2010_15_19_55_+1100_BtsVC_PDsHOnqjPE
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

On Mon, 18 Jan 2010 15:16:39 -0800 (PST) Sage Weil <sage@newdream.net> wrot=
e:
>
> That works, thanks.  I was planning on just making sure my tree got pulle=
d=20
> after the vfs tree, but this will work either way.

It looks like you added my patch to your tree, but did not merge Al's
write_inode branch.  So, I assume that your tree is currently broken if
built on its own.

> More generally, I'm not sure I understand how your fixups are supposed to=
=20
> be used down the line.  Is whichever tree that caused the conflict to get=
=20
> merged second supposed to pick it up in their branch to pull, or are thos=
e=20
> patches being fed to Linus somehow, or does he usually fix up those=20
> conflicts himself?

Yeah, either the second tree's owner will do the fixup after the first is
merged into Linus' tree or (more commonly for simple fixups), Linus will
do the fix when he merges the second tree.  In this particular case, the
conflicts are not noticed by git during the merge, so they need to be
done manually by the second tree's owner, or by Linus (if we tell him).

I will attempt to remember to warn Linus if these conflicts remain during
the next merge window but if you and J=C3=B6rn merge Al's branch and apply =
the
fix, then it will all be OK.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Jan_2010_15_19_55_+1100_BtsVC_PDsHOnqjPE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVMusACgkQjjKRsyhoI8zKNQCgwG05cfPMuE+3sm38jSshtDdp
KE8An0/iy53ETjrahgCenUcpsdeV2wXc
=eMQP
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jan_2010_15_19_55_+1100_BtsVC_PDsHOnqjPE--
