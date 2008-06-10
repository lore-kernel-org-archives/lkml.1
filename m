Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYFJEmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYFJEmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYFJEmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:42:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37433 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYFJEmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:42:46 -0400
Date: Tue, 10 Jun 2008 14:42:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: kbuild-current build failure
Message-Id: <20080610144239.dab6187e.sfr@canb.auug.org.au>
In-Reply-To: <20080610043348.GB31765@uranus.ravnborg.org>
References: <20080610110842.30c90c61.sfr@canb.auug.org.au>
	<20080610043348.GB31765@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Jun_2008_14_42_39_+1000_wy3r8ELovxaNbby+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jun_2008_14_42_39_+1000_wy3r8ELovxaNbby+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Tue, 10 Jun 2008 06:33:48 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> > This is Linus' tree with just the net-current, arm-current and
> > kbuild-current trees merged i.e. just bug fixes queued for Linus' curre=
nt
> > tree.  The build was done with "O=3D../powerpc_ppc64_defconfig -j24 -s"
> > i.e. separate object tree and parallel.
> >=20
> > Reverting commit 68e9b79c8dad5245f28ab4f3527481b730dbdb61 ("kbuild:
> > simplify vmlinux link stage") makes the build work again.
>=20
> This commit is in kbuild-next.git (for the merge window)
> My kbuild-fixes.git is empty at the moment.

Oops, sorry my mistake - I have the same tree listed for kbuild-current
and kbuild (next). :-(  I will fix it up for tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jun_2008_14_42_39_+1000_wy3r8ELovxaNbby+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhOBj8ACgkQTgG2atn1QN+TYQCfVNQWgtpHKalOVb4nQTD7kVQd
AvYAn15cNO0e7uUcFo9Msg8f0jAOSaiW
=B27O
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jun_2008_14_42_39_+1000_wy3r8ELovxaNbby+--
