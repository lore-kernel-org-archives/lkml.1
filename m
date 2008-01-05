Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYAEKFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYAEKFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 05:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYAEKFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 05:05:03 -0500
Received: from mail.isohunt.com ([208.71.112.20]:42273 "EHLO mail.isohunt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYAEKFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 05:05:00 -0500
Date: Sat, 5 Jan 2008 02:04:55 -0800
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Idle loadavg of ~1, maybe MD related
Message-ID: <20080105100455.GB911@curie-int.orbis-terrarum.net>
References: <20071230100614.GX17327@curie-int.orbis-terrarum.net> <20080105013037.a354b33a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <20080105013037.a354b33a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 05, 2008 at 01:30:37AM -0800, Andrew Morton wrote:
> >From that I'd suspect that kwindfarm is being a bad citizen.
> If a process is consistently stuck in D state, run
Windfarm.

> 	echo w > /proc/sysrq-trigger
> then record the resulting dmesg output so we can see where it got stuck.

Traceback:
[552710.416174] SysRq : Show Blocked State
[552710.417876]   task                        PC stack   pid father
[552710.417888] kwindfarm     D 0000000000000000     0   829      2
[552710.417892] Call Trace:
[552710.417895] [c00000036c9835f0] [c000000000528b90] 0xc000000000528b90 (u=
nreliable)
[552710.417908] [c00000036c9837c0] [c00000000000f4a8] .__switch_to+0xd8/0x1=
10
[552710.417985] [c00000036c983850] [c0000000003bb2a0] .schedule+0x62c/0x6c8
[552710.417992] [c00000036c983940] [c0000000003bb8c4] .schedule_timeout+0x3=
c/0xe8
[552710.417997] [c00000036c983a10] [c0000000003bb51c] .wait_for_common+0x10=
0/0x1bc
[552710.418002] [c00000036c983ae0] [c000000000285300] .smu_fan_set+0x17c/0x=
1e4
[552710.418009] [c00000036c983c30] [c000000000284078] .pm112_wf_notify+0xc5=
0/0x12d0
[552710.418015] [c00000036c983d20] [c0000000003bfb84] .notifier_call_chain+=
0x5c/0xcc
[552710.418021] [c00000036c983dc0] [c00000000006f4b4] .__blocking_notifier_=
call_chain+0x70/0xb0
[552710.418027] [c00000036c983e70] [c000000000282d9c] .wf_thread_func+0x78/=
0x11c
[552710.418032] [c00000036c983f00] [c000000000069b00] .kthread+0x78/0xc4
[552710.418039] [c00000036c983f90] [c000000000023d0c] .kernel_thread+0x4c/0=
x68
[552710.418064] Sched Debug Version: v0.07, 2.6.24-rc6-prod-g6f0f5304 #10
[552710.418067] now at 552723945.170635 msecs
[552710.418070]   .sysctl_sched_latency                    : 60.000000
[552710.418073]   .sysctl_sched_min_granularity            : 12.000000
[552710.418076]   .sysctl_sched_wakeup_granularity         : 30.000000
[552710.418079]   .sysctl_sched_batch_wakeup_granularity   : 30.000000
[552710.418082]   .sysctl_sched_child_runs_first           : 0.000001
[552710.418085]   .sysctl_sched_features                   : 7

Full output at
http://dev.gentoo.org/~robbat2/20080105_windfarm_sysrq_w.txt

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAkd/VkcACgkQPpIsIjIzwiwMSACfWkMzPWiWGlwwcQU5XMd5PbAB
zmMAn351fJtiNnbsoRVi2aUv10Rau7M1
=oZqf
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
