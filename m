Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXKSCiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXKSCiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 21:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXKSCit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 21:38:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56586 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbXKSCis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 21:38:48 -0500
Date: Mon, 19 Nov 2007 13:38:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linuxppc-dev@ozlabs.org, anton@au1.ibm.com,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.24-rc2-mm1 powerpc (iseries)- build failure -
 mm/stab.c
Message-Id: <20071119133849.bcfe52c1.sfr@canb.auug.org.au>
In-Reply-To: <20071114105410.GA16846@linux.vnet.ibm.com>
References: <20071114105410.GA16846@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Nov_2007_13_38_49_+1100_xyk31yLXh2SRmrC."
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Nov_2007_13_38_49_+1100_xyk31yLXh2SRmrC.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Wed, 14 Nov 2007 16:24:10 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> +#ifdef CONFIG_PPC_ISERIES
> +#include <asm/iseries/hv_call.h>
> +#endif /* CONFIG_PPC_ISERIES */

You should not need the #ifdef and we prefer not to ifdef include unless
necessary.  Please resubmit.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Nov_2007_13_38_49_+1100_xyk31yLXh2SRmrC.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHQPc+TgG2atn1QN8RAh1RAJ47QqPkhtAVx4E+cQrivYhDDiqB6ACggkrS
T7OqZN4gyXYmukKyGdprf+8=
=JXY1
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Nov_2007_13_38_49_+1100_xyk31yLXh2SRmrC.--
