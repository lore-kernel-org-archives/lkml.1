Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120Ab0ASAMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0ASAMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218Ab0ASAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:12:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0ASAMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:12:33 -0500
Date: Tue, 19 Jan 2010 11:12:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Linus <torvalds@linux-foundation.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build warning
Message-Id: <20100119111226.c9405ac7.sfr@canb.auug.org.au>
In-Reply-To: <20100118164039.8da6403e.sfr@canb.auug.org.au>
References: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>
	<20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
	<6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F8@shzsmsx501.ccr.corp.intel.com>
	<20100118164039.8da6403e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Jan_2010_11_12_26_+1100_0QJTvIu_SB+uBtPa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jan_2010_11_12_26_+1100_0QJTvIu_SB+uBtPa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fengguang,

On Mon, 18 Jan 2010 16:40:39 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 18 Jan 2010 12:29:52 +0800 "Wu, Fengguang" <fengguang.wu@intel.co=
m> wrote:
> >
> > On Mon, 18 Jan 2010 15:05:01 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > > >
> > > > It actually looks like commit c29af9636 ("sysdev: Pass attribute in
> > > > sysdev_class attributes show/store") referred to in the changelog f=
or the
> > > > above commit has not yet been applied to Linus' tree?
> > >
> > > Commit c29af9636 ("sysdev: Pass attribute in sysdev_class attributes
> > > show/store") does appear in linux-next since next-20100111 (in the
> > > driver-core quilt series - therefore intended for 2.6.34) (it will ha=
ve a
> > > different SHA1 today)
> >=20
> > So let's queue 8ff410daa009c (sysdev: fix prototype for memory_sysdev_c=
lass show/store functions)
> > in driver-core and delay it to 2.6.34?
>=20
> Then it would need to be reverted from Linus' tree.

I have reverted commit 8ff410daa009c for today.  It looks like Greg
already has the alternate patches queued in the driver-core tree to take
care of this problem when it arises.

So, Greg, can you ask Linus to revert 8ff410daa009c (sysdev: fix
prototype for memory_sysdev_class show/store functions), please?  Or
should I?  Or should we hope he notices these emails? :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Jan_2010_11_12_26_+1100_0QJTvIu_SB+uBtPa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktU+OoACgkQjjKRsyhoI8xJ7ACgiul0BzyId7pwHs67w5EVA/BX
PeoAn0xOL0CsbZxyw3JQDIgySj0Kl3F5
=azVh
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jan_2010_11_12_26_+1100_0QJTvIu_SB+uBtPa--
