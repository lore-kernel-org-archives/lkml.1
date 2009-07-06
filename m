Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZGFGOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZGFGOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZGFGOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:14:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50966 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbZGFGOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:14:33 -0400
Date: Mon, 6 Jul 2009 16:14:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <sfi-devel@simplefirmware.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: sfi tree build failure
Message-Id: <20090706161432.111a42ee.sfr@canb.auug.org.au>
In-Reply-To: <20090630171937.75f64662.sfr@canb.auug.org.au>
References: <20090630171937.75f64662.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Jul_2009_16_14_32_+1000_inBaQoQjiAGzsfXh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jul_2009_16_14_32_+1000_inBaQoQjiAGzsfXh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 30 Jun 2009 17:19:37 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>=20
> In file included from include/acpi/platform/acenv.h:141,
>                  from include/acpi/acpi.h:56,
>                  from include/linux/acpi.h:38,
>                  from init/main.c:27:
> include/acpi/platform/aclinux.h:64:22: error: asm/acpi.h: No such file or=
 directory
> In file included from include/acpi/platform/aclinux.h:130,
>                  from include/acpi/platform/acenv.h:141,
>                  from include/acpi/acpi.h:56,
>                  from include/linux/acpi.h:38,
>                  from init/main.c:27:
> include/acpi/actypes.h:130: error: expected '=3D', ',', ';', 'asm' or '__=
attribute__' before 'UINT64'
> include/acpi/actypes.h:131: error: expected '=3D', ',', ';', 'asm' or '__=
attribute__' before 'INT64'
> include/acpi/actypes.h:910: error: expected ')' before '*' token
> include/acpi/actypes.h:913: error: expected ')' before '*' token
>=20
> and it went downhill from there :-(
>=20
> I have dropped the sfi tree for today.

And the sfi tree has still not made it into linux-next as the above error
still exists.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Jul_2009_16_14_32_+1000_inBaQoQjiAGzsfXh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRlkgACgkQjjKRsyhoI8yPaACfSPMlwYN4Fsn/sGr5EOmhw5sv
PRoAn0UQ2RRGOGsNOvtCZYCPhvhXT96O
=tZXG
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jul_2009_16_14_32_+1000_inBaQoQjiAGzsfXh--
