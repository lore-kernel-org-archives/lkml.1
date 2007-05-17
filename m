Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbXEQAU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbXEQAU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbXEQAUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:20:49 -0400
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:36146 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbXEQAUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:20:49 -0400
Date: Wed, 16 May 2007 14:26:14 -1000
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
To: Daniel Drake <dsd@gentoo.org>
Cc: davej@redhat.com, duaneg@dghda.com, prakash@punnoor.de,
       linux-kernel@vger.kernel.org, Ed Sweetman <safemode2@comcast.net>
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517002614.GU15763@ifa.hawaii.edu>
References: <20070516235050.9B4237B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqSMaTz1cCSspCQ4"
Content-Disposition: inline
In-Reply-To: <20070516235050.9B4237B409F@zog.reactivated.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tqSMaTz1cCSspCQ4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I don't think this is quiet right either as Ed Sweetman has reported
that this issue doesn't occur on single socket/multi-core systems.

-J

--
On Thu, May 17, 2007 at 12:50:50AM +0100, Daniel Drake wrote:
> powernow-k8 uses PSB BIOS tables to read frequency info on UP systems, but
> on SMP it requires the acpi-processor driver. Kconfig should be updated
> accordingly to avoid the issues that users are running into.
>=20
> http://bugzilla.kernel.org/show_bug.cgi?id=3D8075
> https://bugs.gentoo.org/show_bug.cgi?id=3D178585
>=20
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
>=20
> Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
> +++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
> @@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
>  config X86_POWERNOW_K8
>  	tristate "AMD Opteron/Athlon64 PowerNow!"
>  	select CPU_FREQ_TABLE
> +	select ACPI_PROCESSOR if SMP
>  	depends on EXPERIMENTAL
>  	help
>  	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processo=
rs.

--tqSMaTz1cCSspCQ4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGS6EmWa2BU+b7tU0RArntAJ4nIi7HfxrIm5F/gjU2V4jycBAOUQCfW+dl
1b/86z+7gmJlNQVwrQ/Q8gg=
=ZbKX
-----END PGP SIGNATURE-----

--tqSMaTz1cCSspCQ4--
