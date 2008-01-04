Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYADEQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYADEQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 23:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYADEQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 23:16:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40619 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYADEQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 23:16:01 -0500
Date: Fri, 4 Jan 2008 15:15:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <ak@suse.de>
Cc: hpa@rpath.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [11/16] Compile apm and voyager module only when
 selected in Kconfig
Message-Id: <20080104151547.94e4136d.sfr@canb.auug.org.au>
In-Reply-To: <20080103154225.566C514DDB@wotan.suse.de>
References: <20080103442.621670000@suse.de>
	<20080103154225.566C514DDB@wotan.suse.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Jan_2008_15_15_47_+1100_1YKsY_WV7xe.07vF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jan_2008_15_15_47_+1100_1YKsY_WV7xe.07vF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu,  3 Jan 2008 16:42:25 +0100 (CET) Andi Kleen <ak@suse.de> wrote:
>
> +++ linux/arch/x86/Kconfig
> @@ -1219,6 +1219,11 @@ source "kernel/power/Kconfig"
> =20
>  source "drivers/acpi/Kconfig"
> =20
> +config X86_APM_BOOT
> +	bool
> +	default y
> +	depends on APM

Does this want to be
	depends on APM || APM_MODULE

> +++ linux/arch/x86/boot/apm.c
> @@ -19,8 +19,6 @@
> =20
>  #include "boot.h"
> =20
> -#if defined(CONFIG_APM) || defined(CONFIG_APM_MODULE)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Jan_2008_15_15_47_+1100_1YKsY_WV7xe.07vF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHfbL3TgG2atn1QN8RAhfrAJ0RGt1qHq1Hz+h+WheFanvt9abp0ACePml6
NFkoTsN/uqjE24gL0RGnAtg=
=bRil
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2008_15_15_47_+1100_1YKsY_WV7xe.07vF--
