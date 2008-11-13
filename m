Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYKMKVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYKMKVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYKMKVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:21:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42799 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYKMKVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:21:38 -0500
Date: Thu, 13 Nov 2008 21:21:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-kernel@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>,
       Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] xsysace: use resource_size_t instead of unsigned long
Message-Id: <20081113212121.e7a9f5fe.sfr@canb.auug.org.au>
In-Reply-To: <200811131143.17752.yur@emcraft.com>
References: <200811131143.17752.yur@emcraft.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Nov_2008_21_21_21_+1100_Vnx4uizXowUDlsiM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Nov_2008_21_21_21_+1100_Vnx4uizXowUDlsiM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yuri,

On Thu, 13 Nov 2008 11:43:17 +0300 Yuri Tikhonov <yur@emcraft.com> wrote:
>
> -	dev_dbg(ace->dev, "physaddr=3D0x%lx irq=3D%i\n", ace->physaddr, ace->ir=
q);
> +	dev_dbg(ace->dev, "physaddr=3D0x%llx irq=3D%i\n", (u64)ace->physaddr, a=
ce->irq);

You should cast the physaddr to "unsigned long long" as "u64" is
"unsigned long" on some architectures.  The same is needed in other
places as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Nov_2008_21_21_21_+1100_Vnx4uizXowUDlsiM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkb/6EACgkQjjKRsyhoI8wiTgCePjrm9Y10duP0TWuRfNLCJZJr
iCQAnjxvR/sTUu2/GrgcESdm1jeRONVB
=4C8A
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Nov_2008_21_21_21_+1100_Vnx4uizXowUDlsiM--
