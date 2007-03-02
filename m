Return-Path: <linux-kernel-owner+w=401wt.eu-S2992527AbXCBPnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992527AbXCBPnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992528AbXCBPnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:43:03 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54103 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992527AbXCBPnB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:43:01 -0500
Message-Id: <200703021542.l22FgtLQ012239@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1 - build error with HOTPLUG_CPU=N, CPU_IDLE=Y
In-Reply-To: Your message of "Fri, 02 Mar 2007 03:00:26 PST."
             <20070302030026.5eef0c92.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1172850175_4365P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Mar 2007 10:42:55 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1172850175_4365P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Mar 2007 03:00:26 PST, Andrew Morton said:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-=
rc2/2.6.21-rc2-mm1/

>  git-acpi.patch

Build dies if your config has CONFIG_HOTPLUG_CPU=3DN but CPU_IDLE=3DY

  CC      drivers/cpuidle/cpuidle.o
drivers/cpuidle/cpuidle.c: In function =E2=80=98cpuidle_init=E2=80=99:
drivers/cpuidle/cpuidle.c:272: error: =E2=80=98cpuidle_cpu_notifier=E2=80=
=99 undeclared (first use in this function)
drivers/cpuidle/cpuidle.c:272: error: (Each undeclared identifier is repo=
rted only once
drivers/cpuidle/cpuidle.c:272: error: for each function it appears in.)
make=5B2=5D: *** =5Bdrivers/cpuidle/cpuidle.o=5D Error 1

Not sure if we're missing some Kconfig 'depends on' magic, or a missing
pair of =23ifdef/=23endif, or what...

--==_Exmh_1172850175_4365P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF6EX/cC3lWbTT17ARAgNsAJ9Xv7rwBdlU8HOYoVx6cspWtc8UZQCfWTLj
e+wksBs1EoNvhgXz+SR7afA=
=1987
-----END PGP SIGNATURE-----

--==_Exmh_1172850175_4365P--
