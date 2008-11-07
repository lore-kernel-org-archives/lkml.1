Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbYKGFVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbYKGFVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbYKGFV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:21:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60142 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYKGFV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:21:28 -0500
Date: Fri, 7 Nov 2008 16:21:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
Message-Id: <20081107162114.2a41c623.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0811061310350.6009@quilx.com>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
	<20081106183939.GA26925@x200.localdomain>
	<Pine.LNX.4.64.0811061310350.6009@quilx.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Nov_2008_16_21_14_+1100_uSi1=TsWGmz_/.gl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Nov_2008_16_21_14_+1100_uSi1=TsWGmz_/.gl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Thu, 6 Nov 2008 13:15:07 -0600 (CST) Christoph Lameter <cl@linux-foundat=
ion.org> wrote:
>
> On Thu, 6 Nov 2008, Alexey Dobriyan wrote:
>=20
> > On blackfin-BF526-EZBRD and other blackfins:
> >
> >   LD      .tmp_vmlinux1
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x1486): undefined reference to `__per_cpu_start'
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x148c): undefined reference to `__per_cpu_start'
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x1492): undefined reference to `__per_cpu_end'
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x1496): undefined reference to `__per_cpu_end'
>=20
> Any contigencies for __per_cpu_start/end in your blackfin vmlinux.lds.h?
> That is where these symbols are defined
>=20
> Or did you use generic percpu support and set
> CONFIG_HAVE_ZERO_BASED_PER_CPU?

Also a avr32 allnoconfig
(http://kisskb.ellerman.id.au/kisskb/buildresult/53233/) gets:

backing-dev.c:(.init.text+0xc4c): undefined reference to `__per_cpu_start'
backing-dev.c:(.init.text+0xc50): undefined reference to `__per_cpu_end'

and avr32 defconfig
(http://kisskb.ellerman.id.au/kisskb/buildresult/53225/) gets:

vmstat.c:(.init.text+0xff0): undefined reference to `__per_cpu_start'
vmstat.c:(.init.text+0xff4): undefined reference to `__per_cpu_end'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Nov_2008_16_21_14_+1100_uSi1=TsWGmz_/.gl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkT0EoACgkQjjKRsyhoI8wnOwCgoiZhSfkJdYCSs+N6eMNkd0cX
rDAAoKHnOI6QDCd3rQ5PzLA58exJgCpa
=SGH9
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_16_21_14_+1100_uSi1=TsWGmz_/.gl--
