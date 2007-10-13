Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbXJMIza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbXJMIza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXJMIzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:55:22 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:48266 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbXJMIzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:55:21 -0400
X-Greylist: delayed 79495 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 04:55:20 EDT
Subject: Re: [PATCH] sched: high-res preemption tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192259938.7369.4.camel@Homer.simpson.net>
References: <1192222309.5897.3.camel@lappy>
	 <1192259938.7369.4.camel@Homer.simpson.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hl/IDw9/eQLnwtm6ZeNf"
Date: Sat, 13 Oct 2007 10:55:17 +0200
Message-Id: <1192265717.27435.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hl/IDw9/eQLnwtm6ZeNf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-13 at 09:18 +0200, Mike Galbraith wrote:
> On Fri, 2007-10-12 at 22:51 +0200, Peter Zijlstra wrote:
> > Subject: sched: high-res preemption tick
> >=20
> > Use HR-timers (when available) to deliver an accurate preemption tick.
>=20
> This patch further reduced iperf context switching, and boosted
> throughput.
>=20
> iperf -c localhost -P 10 -t 300
>=20
> Previously reported numbers
>=20
> 2.6.23-smp
> [SUM]  0.0-300.0 sec    153 GBytes  4.39 Gbits/sec
> [SUM]  0.0-300.1 sec    148 GBytes  4.23 Gbits/sec
> [SUM]  0.0-300.0 sec    152 GBytes  4.36 Gbits/sec
>=20
> 2.6.23-smp-d (sched-devel)
> [SUM]  0.0-300.0 sec    173 GBytes  4.96 Gbits/sec
> [SUM]  0.0-300.1 sec    173 GBytes  4.96 Gbits/sec
> [SUM]  0.0-300.0 sec    172 GBytes  4.93 Gbits/sec
>=20
> Numbers from fresh pull today
>=20
> 2.6.23-smp-d-hrt
> (re-enable PREEMPT_RESTRICT)

Ah, but HRTICK is not compatible with PREEMPT_RESTRICT, it will be
similar to !WAKEUP_PREEMPT.

> [SUM]  0.0-300.1 sec    181 GBytes  5.19 Gbits/sec
> [SUM]  0.0-300.0 sec    182 GBytes  5.22 Gbits/sec
> [SUM]  0.0-300.1 sec    182 GBytes  5.22 Gbits/sec
>=20
> 2.6.23-smp-d
> [SUM]  0.0-300.1 sec    174 GBytes  4.97 Gbits/sec
> [SUM]  0.0-300.1 sec    173 GBytes  4.95 Gbits/sec
> [SUM]  0.0-300.1 sec    173 GBytes  4.96 Gbits/sec
>=20
>=20

--=-Hl/IDw9/eQLnwtm6ZeNf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHEIf1XA2jU0ANEf4RAlUCAJsH/ImWcl9+wSs8+I/LWr376YNiUgCeIaap
rVRrx2J/V4ewldyJCLj0rXw=
=ua2B
-----END PGP SIGNATURE-----

--=-Hl/IDw9/eQLnwtm6ZeNf--

