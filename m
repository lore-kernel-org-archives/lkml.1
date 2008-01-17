Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYAQMrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYAQMrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYAQMq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:46:56 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:48098 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756777AbYAQMqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:46:53 -0500
Date: Thu, 17 Jan 2008 13:46:47 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1
Message-ID: <20080117124647.GK5859@pengutronix.de>
Mail-Followup-To: Wolfgang Grandegger <wg@grandegger.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zH41lVBEV8cLJnCl"
Content-Disposition: inline
In-Reply-To: <478F2A46.5070506@grandegger.com>
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
X-Uptime: 13:40:06 up 10 days,  4:29,  1 user,  load average: 0.69, 0.61,
	0.68
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zH41lVBEV8cLJnCl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfgang,

On Thu, Jan 17, 2008 at 11:13:26AM +0100, Wolfgang Grandegger wrote:
> Steven Rostedt wrote:
> It builds and runs fine on my Icecube-MPC5200 board, now also with the
> latency tracer enabled. That's great. Still, "cyclictest -n -p80 -i1000"
> reports latencies up to 400 us and therefore I tried to trigger and save
> a high latency trace using:
>=20
>   # ./cyclictest -n -p80 -i1000 -b400
>   1.21 0.33 0.11 4/42 1048
>=20
>   T: 0 (  914) P:80 I:1000 C:  38726 Min:     61 Act:  107 Avg:  106
> Max:     377
>   [   91.042169] (      cyclictest-914  |#0): new 39733427 us user-latenc=
y.
>   bash-3.00# cat /proc/latency_trace > trace.log
>=20

I tested 2.6.24-rc8-rt1 on our phytec phyCORE-MPC5200B-tiny. I runned cycli=
ctest
with exactly the same parameter as you used and made some non-rt Workload w=
ith
"hackbench 5" in a while 1 loop and a "ping -f" from a host machine. I run =
the
test for about 3 hours and could not push the latency to higher than 220 us.
(The latency tracer is also turned on in kernel). Could you please send me =
your
kernelconfig privately?

cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--zH41lVBEV8cLJnCl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHj040iruQY+UyUmERAoIUAJ4kJ6+H8iWtWoqg9X0RDq8uFXqDPQCeJT18
7ykRHYirV77EzkuphzvN7ro=
=JFyf
-----END PGP SIGNATURE-----

--zH41lVBEV8cLJnCl--
