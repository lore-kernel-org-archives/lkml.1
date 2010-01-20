Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909Ab0ATGox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0ATGox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828Ab0ATGot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:44:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40874 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab0ATGor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:44:47 -0500
Date: Wed, 20 Jan 2010 17:44:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20100120174441.e1b12fd7.sfr@canb.auug.org.au>
In-Reply-To: <20100120172543.e884a8af.sfr@canb.auug.org.au>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
	<20100119210417.GC10928@kroah.com>
	<20100120104525.752a790f.sfr@canb.auug.org.au>
	<20100120172543.e884a8af.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_17_44_41_+1100_Wi8/boimbbWybOhd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_17_44_41_+1100_Wi8/boimbbWybOhd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 20 Jan 2010 17:25:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> (lines 262-266)
> static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] =3D {
> #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
>         &class_attr_probe.attr,
>         &class_attr_release.attr,
> #endif

The reason you may not see this is because CONFIG_ARCH_CPU_PROBE_RELEASE
is not set for x86_64 allmodconfig builds (and probably many others).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_17_44_41_+1100_Wi8/boimbbWybOhd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAktWplkACgkQjjKRsyhoI8xuzACY5bl2SIfGeqkJP0RGj+CnC8nO
YgCfcjOIogLyClKdBgDXkW1/EE4AEM0=
=Ixw0
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_17_44_41_+1100_Wi8/boimbbWybOhd--
