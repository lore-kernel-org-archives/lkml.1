Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510Ab0ARFks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab0ARFks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337Ab0ARFkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:40:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52854 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab0ARFkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:40:46 -0500
Date: Mon, 18 Jan 2010 16:40:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Linus <torvalds@linux-foundation.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build warning
Message-Id: <20100118164039.8da6403e.sfr@canb.auug.org.au>
In-Reply-To: <6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F8@shzsmsx501.ccr.corp.intel.com>
References: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>
	<20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
	<6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F8@shzsmsx501.ccr.corp.intel.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_16_40_39_+1100_xC5Y_bzQNgV7=F+w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_16_40_39_+1100_xC5Y_bzQNgV7=F+w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fengguang,

On Mon, 18 Jan 2010 12:29:52 +0800 "Wu, Fengguang" <fengguang.wu@intel.com>=
 wrote:
>
> On Mon, 18 Jan 2010 15:05:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> > >
> > > It actually looks like commit c29af9636 ("sysdev: Pass attribute in
> > > sysdev_class attributes show/store") referred to in the changelog for=
 the
> > > above commit has not yet been applied to Linus' tree?
> >
> > Commit c29af9636 ("sysdev: Pass attribute in sysdev_class attributes
> > show/store") does appear in linux-next since next-20100111 (in the
> > driver-core quilt series - therefore intended for 2.6.34) (it will have=
 a
> > different SHA1 today)
>=20
> So let's queue 8ff410daa009c (sysdev: fix prototype for memory_sysdev_cla=
ss show/store functions)
> in driver-core and delay it to 2.6.34?

Then it would need to be reverted from Linus' tree.

Greg?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_16_40_39_+1100_xC5Y_bzQNgV7=F+w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktT9FcACgkQjjKRsyhoI8xkuQCaAjmdttZhViJRK7qATxgGijvS
4x4AoJQle58hz0PwYFbjMi/iMHiAmT5K
=UnqO
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_16_40_39_+1100_xC5Y_bzQNgV7=F+w--
