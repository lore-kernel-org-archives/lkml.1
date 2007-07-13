Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbXGMDXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbXGMDXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbXGMDX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:23:26 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:55599 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbXGMDX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:23:26 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: CPUFreq compilation failure with current GIT.
Date: Fri, 13 Jul 2007 13:23:16 +1000
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3033212.LaC9EBjBS4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707131323.22185.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3033212.LaC9EBjBS4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi.

Current git compilation fails on my amd64:

  CC [M]  arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/acpi-cpufreq.o
  CC [M]  arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.o
arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.c: In function 'powernowk8_init':
arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.c:1334: error: 'struct cpuinfo_x86' has no member named 'booted_cores'
make[2]: *** [arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.o] Error 1
make[1]: *** [arch/x86_64/kernel/cpufreq] Error 2
make: *** [arch/x86_64/kernel] Error 2

The following commit apparently wasn't tested on x86_64 as well:

Commit: 904f7a3f042b5c6aa9e53ce83f2c9de5e33170ff
Author: Dave Jones <davej@redhat.com> Fri, 18 May 2007 13:22:28 -0400

    [CPUFREQ] powernow-k8: clarify number of cores.

    Indicate number of processors and cores more cleanly
    in startup messages.

    Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

Regards,

Nigel

--nextPart3033212.LaC9EBjBS4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlvAqN0y+n1M3mo0RAqznAKCTKm/a8s7muh3NYRFhFqYzK6fKXgCdFqWI
tFnFlMvuuN5EF/wIDJdU+1E=
=wMve
-----END PGP SIGNATURE-----

--nextPart3033212.LaC9EBjBS4--
