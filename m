Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554Ab0BNOIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:08:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35227 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab0BNOIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:08:41 -0500
Date: Mon, 15 Feb 2010 01:08:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 16/35] x86: make 64 bit use early_res instead of bootmem
 before slab
Message-Id: <20100215010833.15f9e09a.sfr@canb.auug.org.au>
In-Reply-To: <1265793639-15071-17-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	<1265793639-15071-17-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Feb_2010_01_08_33_+1100_4sz+AF0+GHnrriwD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Feb_2010_01_08_33_+1100_4sz+AF0+GHnrriwD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 10 Feb 2010 01:20:20 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
>
> finally we can use early_res to replace bootmem for x86_64 now.
>=20
> still can use CONFIG_NO_BOOTMEM to enable it or not
>=20
> -v2: fix 32bit compiling about MAX_DMA32_PFN
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

=46rom a powerpc pseries_defconfig build (and others configs) of tip/master
(9d4a5dc3080c811f36bf8175f2de1f9a6f84b176 "Merge branch 'perf/urgent'"):

mm/page_alloc.c:3468: error: implicit declaration of function 'find_early_a=
rea'
mm/page_alloc.c:3483: error: implicit declaration of function 'reserve_earl=
y_without_check'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Feb_2010_01_08_33_+1100_4sz+AF0+GHnrriwD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt4A+EACgkQjjKRsyhoI8x5KwCfXj33V4J0ZWF+jiypWY02CjMg
2SkAnj8R63fyrTXKb+DoZtL1tmTzYt9K
=qhlz
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Feb_2010_01_08_33_+1100_4sz+AF0+GHnrriwD--
