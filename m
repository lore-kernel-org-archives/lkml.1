Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZIQCG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZIQCG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZIQCGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:06:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56245 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZIQCGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:06:55 -0400
Date: Thu, 17 Sep 2009 12:06:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kurt Roeckx <kurt@roeckx.be>
Subject: linux-next: cpufreq-current tree build warning
Message-Id: <20090917120651.f0cdf4c2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_12_06_51_+1000_N5PYZZoos2cvDhD0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_12_06_51_+1000_N5PYZZoos2cvDhD0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function 'fill_powernow_table=
_fidvid':
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1001: warning: passing argument 1=
 of 'invalidate_entry' from incompatible pointer type
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:608: note: expected 'struct cpufr=
eq_frequency_table *' but argument is of type 'struct powernow_k8_data *'

Introduced by commit 7fc1b26613587ab4369615445b5485040c60fef1 ("[CPUFREQ]
Fix NULL ptr regression in powernow-k8").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_12_06_51_+1000_N5PYZZoos2cvDhD0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxmbsACgkQjjKRsyhoI8wACQCfbPww4oRSXbT6m2zkPpXlB+qq
DCQAoIs3zb20CmxkiRUdmnb8NBagNvXE
=KAiK
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_12_06_51_+1000_N5PYZZoos2cvDhD0--
