Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0BBMBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:01:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0BBMBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:01:30 -0500
Date: Tue, 2 Feb 2010 23:01:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: sound tree build failure
Message-Id: <20100202230123.64bee219.sfr@canb.auug.org.au>
In-Reply-To: <1265111430.4194.144.camel@odin>
References: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
	<20100202102609.GA6566@rakim.wolfsonmicro.main>
	<20100202213732.586a3566.sfr@canb.auug.org.au>
	<20100202105800.GE6566@rakim.wolfsonmicro.main>
	<20100202221743.1dbcad11.sfr@canb.auug.org.au>
	<1265111430.4194.144.camel@odin>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Feb_2010_23_01_23_+1100_=FdViIj/=Jd8xmUf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Feb_2010_23_01_23_+1100_=FdViIj/=Jd8xmUf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

On Tue, 02 Feb 2010 11:50:30 +0000 Liam Girdwood <lrg@slimlogic.co.uk> wrot=
e:
>
> I wonder if it would be possible to re-order the merge sequence so that
> similar inter tree dependencies are less likely to cause -next build

Anything is possible with software :-)

> failures in the future.  I guess atm lots of driver trees can depend on
> MFD (e.g. regulator, sound, rtc, backlight, led, watchdog, etc) so it
> may be good to move it up the order.

In this case it would just have masked the dependency and we may not have
found it until the sound tree was merged into Linus' tree and builds
started failing.  (I now Mark already knew about this one.)  We actually
have very few build dependencies between trees and in most cases I would
prefer that they were exposed in linux-next than in Linus' tree (with the
ensuing bisection problems).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Feb_2010_23_01_23_+1100_=FdViIj/=Jd8xmUf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktoFBMACgkQjjKRsyhoI8yw/wCgogRxJSOKrtCgV0up+g6gWhhg
TWwAoIkxsU3e+3pu4XqyHwBFLuEbgChi
=j9Jx
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Feb_2010_23_01_23_+1100_=FdViIj/=Jd8xmUf--
