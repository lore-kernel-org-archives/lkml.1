Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZJSKDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZJSKDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 06:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZJSKDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 06:03:42 -0400
Received: from mail.klingt.org ([86.59.21.178]:38615 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZJSKDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 06:03:41 -0400
Message-ID: <4ADC3975.8050109@klingt.org>
Date: Mon, 19 Oct 2009 12:03:33 +0200
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5pre) Gecko/20091017 Lightning/1.0pre Shredder/3.0pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf stat: add branch performance counters to default
X-Enigmail-Version: 0.96a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig317C427E1847EA65B5523800"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 19 Oct 2009 12:03:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig317C427E1847EA65B5523800
Content-Type: multipart/mixed;
 boundary="------------040500070403000800090307"

This is a multi-part message in MIME format.
--------------040500070403000800090307
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

not sure, whether there is any reason, why the branch performance
counters are not enabled by default.
personally, i would find it quite useful, though

--

this patch adds performance counter information about branches and
branch misses to the default output of perf stat.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)



--------------040500070403000800090307
Content-Type: text/x-patch;
 name="0001-perf-stat-add-branch-performance-counters-to-default.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-perf-stat-add-branch-performance-counters-to-default.pa";
 filename*1="tch"

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e874ad4..671bfaa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -57,6 +57,8 @@ static struct perf_counter_attr default_attrs[] =3D {
   { .type =3D PERF_TYPE_HARDWARE, .config =3D PERF_COUNT_HW_INSTRUCTIONS=
	},
   { .type =3D PERF_TYPE_HARDWARE, .config =3D PERF_COUNT_HW_CACHE_REFERE=
NCES},
   { .type =3D PERF_TYPE_HARDWARE, .config =3D PERF_COUNT_HW_CACHE_MISSES=
	},
+  { .type =3D PERF_TYPE_HARDWARE, .config =3D PERF_COUNT_HW_BRANCH_INSTR=
UCTIONS},
+  { .type =3D PERF_TYPE_HARDWARE, .config =3D PERF_COUNT_HW_BRANCH_MISSE=
S	},
=20
 };
=20


--------------040500070403000800090307--

--------------enig317C427E1847EA65B5523800
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrcOXUACgkQdL+4qsZfVssH7ACdHELwW/6PKtiMGd5YZC38NIhB
FacAnjrlTv7mMgGNAwUuMCgssMuUuS0c
=oCIJ
-----END PGP SIGNATURE-----

--------------enig317C427E1847EA65B5523800--
