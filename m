Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab0BNOQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:16:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33778 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0BNOQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:16:22 -0500
Date: Mon, 15 Feb 2010 01:16:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
Message-Id: <20100215011615.e3d35121.sfr@canb.auug.org.au>
In-Reply-To: <1265793639-15071-28-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	<1265793639-15071-28-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Feb_2010_01_16_15_+1100_YR7rgOPpgVHw1OaF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Feb_2010_01_16_15_+1100_YR7rgOPpgVHw1OaF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 10 Feb 2010 01:20:31 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
>
> from arch/x86 to kernel/
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/e820.h      |    2 +-
>  arch/x86/include/asm/early_res.h |   21 --
>  arch/x86/kernel/Makefile         |    2 +-
>  arch/x86/kernel/e820.c           |    1 -
>  arch/x86/kernel/early_res.c      |  523 --------------------------------=
------
>  include/linux/early_res.h        |   21 ++
>  kernel/Makefile                  |    2 +-
>  kernel/early_res.c               |  522 ++++++++++++++++++++++++++++++++=
+++++
>  8 files changed, 546 insertions(+), 548 deletions(-)
>  delete mode 100644 arch/x86/include/asm/early_res.h
>  delete mode 100644 arch/x86/kernel/early_res.c
>  create mode 100644 include/linux/early_res.h
>  create mode 100644 kernel/early_res.c

=46rom a powerpc pseries_defconfig build (and other configs) of tip/master
(9d4a5dc3080c811f36bf8175f2de1f9a6f84b176 "Merge branch 'perf/urgent'"):

kernel/early_res.c:209: error: 'max_pfn_mapped' undeclared (first use in th=
is function)

max_pfn_mapped is only defined for x86.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Feb_2010_01_16_15_+1100_YR7rgOPpgVHw1OaF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt4Ba8ACgkQjjKRsyhoI8zcjACfWMAw6ggwF7tERcVbF2vcgY/x
iScAoJ55Ig3N1nnzzGxypy+7Lw6383vc
=Pmpb
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Feb_2010_01_16_15_+1100_YR7rgOPpgVHw1OaF--
