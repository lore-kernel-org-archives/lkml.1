Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYGAVM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYGAVM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYGAVMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:12:18 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:59632 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbYGAVMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:12:15 -0400
Date: Tue, 1 Jul 2008 23:11:58 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU
	issue?
Message-ID: <20080701211158.GA8928@pengutronix.de>
Mail-Followup-To: Wolfgang Grandegger <wg@grandegger.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <486A573E.60107@grandegger.com>
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
X-Uptime: 23:07:30 up  9:50, 16 users,  load average: 0.07, 0.15, 0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 10.1.0.65
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfgang,

On Tue, Jul 01, 2008 at 06:11:42PM +0200, Wolfgang Grandegger wrote:
[...]

I'm out of office till next week. I will try to narrow down the issue you
reported on my board asap. Unfortunately I was not able to produce such wor=
st
case results in my test runs till now. Anyhow I'll also have a look at the =
code
segment you found and play a little around there. Hopefully I'll find somet=
hing
useful. ;-)

Cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIap2biruQY+UyUmERApIxAJ4gmry6saieIGVb0cfZjCTuY/E8bwCgj7V+
8KRyCCI/5zFxSMpDF/Iq3AI=
=4tfg
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
