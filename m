Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbZGHAuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbZGHAuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZGHAuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:50:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56707 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbZGHAuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:50:07 -0400
Date: Wed, 8 Jul 2009 10:50:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sfi tree build failure
Message-Id: <20090708105005.3d8facaa.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0907071120230.4244@localhost.localdomain>
References: <20090630171937.75f64662.sfr@canb.auug.org.au>
	<20090706161432.111a42ee.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0907062348130.32467@localhost.localdomain>
	<20090707154353.628365ac.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0907071120230.4244@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jul_2009_10_50_05_+1000_gNjJ1FPzTA2epvop"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jul_2009_10_50_05_+1000_gNjJ1FPzTA2epvop
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Tue, 07 Jul 2009 11:31:06 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
>
> > I still get the same error.
>=20
> git.kernel.org took a long time to update from master.kerne.org
> last night.  (indeed, I was sending patches through e-mail to
> some folks to work around it); so I suspect you pulled the SFI
> tree before the mirror updated and got the same thing you
> got over the weekend.

I fetch from master ... and did get an update.

> surfing to git.kernel.org, it seems to be up to date now.
>=20
> The tree should include this one of interest:
>=20
> commit 4844be551844e05d4b70f0624e9c34fd486d3e33
> Author: Len Brown <len.brown@intel.com>
> Date:   Mon Jul 6 23:57:55 2009 -0400
>=20
>     SFI: revert changes to linux/acpi.h, fix ppc build

It has that now.  When I refetched yesterday, the head of sfi-test branch
was c24b5f47a66895c2f2ac6e8b665c94f7854e32b4 ("SFI: work around ppc build
failure") which is the commit before the above one.

It doesn't matter, hopefully it will be better today.

> Note that Linus pulls from master.kernel.org rather than git.kernel.org
> to avoid any possible sync delay between tree push and his pull.

As do I for the same reason.

> If you have trouble with a copy of the tree that includes
> the commit above, (I don't expect to see the same failure,
> but it is always possible there is another one after this one),
> then please send me the complete build log.

Will do.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jul_2009_10_50_05_+1000_gNjJ1FPzTA2epvop
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpT7T0ACgkQjjKRsyhoI8yKtACgjxWWLxaKZWSPJKBdC9jVF7IZ
pp4An1+ckFTrjwEHVLi3MqdAYgof4RCN
=dtnL
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jul_2009_10_50_05_+1000_gNjJ1FPzTA2epvop--
