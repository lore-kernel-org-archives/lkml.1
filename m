Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbYA3LQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbYA3LQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYA3LQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:16:11 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:51478 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbYA3LQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:16:09 -0500
Date: Wed, 30 Jan 2008 12:15:59 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>, Luotao Fu <l.fu@pengutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU
	issue?
Message-ID: <20080130111559.GC20089@pengutronix.de>
Mail-Followup-To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20080130105715.GE24890@linux.vnet.ibm.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:10:18 up 9 days,  3:02,  1 user,  load average: 0.08, 0.09,
	0.15
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 30, 2008 at 02:57:16AM -0800, Paul E. McKenney wrote:
=2E.....
> > Yes, I used "$ cyclictest -n -t1 -p80 -i1000" to measure the latency. So
> > far, I have not done other tests. Any recommendation?
> > As no-rt load I used "while ls; do ls /bin; done" in one telnet window
> > and "while ./hackbench 10; do ./calibrator 400 32M cali; sleep 30; done"
> > in another. But already "while ls; do ls /bin; done" is enough to
> > trigger the high latencies quickly. Note also, that I work on a root
> > files-ystem mounted via NFS resulting in a lot of network traffic and
> > utilization.
>=20
> I have to ask...
>=20
> Did you see large latencies when -not- running on NFS?
>=20

I cannot speak for Wolfgang but I myself did not get extraordinary high
latencies running tests on system booted from flash. Neither I could produce
high latencies on nfs booted system. If my non-rt workload doesn't do heavy
filesystem/network accesses. i.E. running only hackbench. Hence we were
wondering if the problem is caused by rcu's in network layer or nfs
implementation.

regards
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHoFxviruQY+UyUmERAlp0AJ9DJj0B9iQQYsnIipvswNRRwIqdGQCffvix
LW+qOJQP1/d6DHlXijCHNH0=
=0GxU
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
