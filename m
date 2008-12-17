Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760224AbYLQJ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYLQJ5c (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYLQJ5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:57:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33925 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYLQJ5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:57:17 -0500
Date: Wed, 17 Dec 2008 20:57:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem.Bityutskiy@nokia.com
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: mtd tree build failures (Was: Re: linux-next: Tree
 for December 16)
Message-Id: <20081217205706.378973c5.sfr@canb.auug.org.au>
In-Reply-To: <4948C71C.2000700@nokia.com>
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
	<20081216152607.f232fafd.akpm@linux-foundation.org>
	<20081217175911.594ae84f.sfr@canb.auug.org.au>
	<4948C71C.2000700@nokia.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Dec_2008_20_57_06_+1100_gEb5rZZHlY+SEZ+m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Dec_2008_20_57_06_+1100_gEb5rZZHlY+SEZ+m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Wed, 17 Dec 2008 11:32:12 +0200 Artem Bityutskiy <Artem.Bityutskiy@nokia=
.com> wrote:
>
> It would be nice if you sent the error messages. I do not have m68k
> compilers, but I could fix the errors anyway, because it is just
> about doing divisions with 'do_div()'.

Normally I would have sent them, but they are basically the same error as
i386 gets.

arm: (various configs)

hid-input.c:(.text+0x41470): undefined reference to `__umoddi3'
hid-input.c:(.text+0x4148c): undefined reference to `__umoddi3'
hid-input.c:(.text+0x41504): undefined reference to `__udivdi3'
drivers/mtd/devices/mtd_dataflash.c:161: undefined reference to `__umoddi3'
drivers/mtd/devices/mtd_dataflash.c:161: undefined reference to `__umoddi3'
drivers/mtd/devices/mtd_dataflash.c:181: undefined reference to `__udivdi3'
i2c-dev.c:(.text+0x4d424): undefined reference to `__umoddi3'
i2c-dev.c:(.text+0x4d44c): undefined reference to `__umoddi3'
i2c-dev.c:(.text+0x4d4b4): undefined reference to `__udivdi3'

m68k: (allmodconfig)
ERROR: "__udivdi3" [drivers/mtd/devices/mtd_dataflash.ko] undefined!
ERROR: "__umoddi3" [drivers/mtd/devices/mtd_dataflash.ko] undefined!
ERROR: "__umoddi3" [drivers/mtd/devices/m25p80.ko] undefined!

All these are from: http://kisskb.ellerman.id.au/kisskb/branch/9/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Dec_2008_20_57_06_+1100_gEb5rZZHlY+SEZ+m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklIzPIACgkQjjKRsyhoI8yz0gCfdJM1CrLI8sLmZkfaOvsLcvSZ
FnkAn39PWH5sfNi18FJ7+8A6Dok0X4Li
=uKqp
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Dec_2008_20_57_06_+1100_gEb5rZZHlY+SEZ+m--
