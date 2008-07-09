Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYGIOwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYGIOwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYGIOwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:52:25 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:51976 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbYGIOwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:52:24 -0400
Date: Wed, 9 Jul 2008 16:52:17 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU
	issue?
Message-ID: <20080709145217.GB30586@pengutronix.de>
Mail-Followup-To: Wolfgang Grandegger <wg@grandegger.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com> <48709348.6000101@grandegger.com> <20080708150826.GA30586@pengutronix.de> <4873C363.3070306@grandegger.com> <4874B4C0.5090500@pengutronix.de> <4874B9D5.1020309@grandegger.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <4874B9D5.1020309@grandegger.com>
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
X-Uptime: 15:27:42 up 2 days,  5:07,  2 users,  load average: 0.05, 0.08,
	0.08
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 10.1.0.86
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfgang,
On Wed, Jul 09, 2008 at 03:15:01PM +0200, Wolfgang Grandegger wrote:
> Hi Fu (without n)
>
=2E...
> OK, in the past you have been able to reproduce the high latencies with =
=20
> 2.6.24-rt1 and CONFIG_RCU_TRACE disabled, IIRC. Did you use a different =
=20
> toolchain at that time?
>

Nope. As mentioned above, trace_mark() does some "real" works (what ever it=
 is.),
while the new mechahnismen use flags to remember the state of preemption. M=
aybe
something here got optimized away? I take for grant, that you use gcc in yo=
ur
toolchain. Which version do you have?

cheers
Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIdNChiruQY+UyUmERAu8/AJ0VXl1MceCxuan2VnqdWQanUD4kngCbBWH/
Yk+9LbLLB8xFC8AM/XJ7v/s=
=0sZ/
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
