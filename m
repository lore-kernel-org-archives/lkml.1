Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbXINMR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbXINMR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXINMRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:17:19 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52973 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753127AbXINMRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:17:18 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0709141352430.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709120242040.1817@scrub.home>
	 <20070913075258.GA9173@elte.hu>
	 <Pine.LNX.4.64.0709131419170.1817@scrub.home>
	 <20070913142842.GA26016@elte.hu>
	 <Pine.LNX.4.64.0709131706100.1817@scrub.home>
	 <1189703165.21778.258.camel@twins>
	 <Pine.LNX.4.64.0709141352430.1817@scrub.home>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cEr0g5hhZYsZtWF9rWLy"
Date: Fri, 14 Sep 2007 14:17:15 +0200
Message-Id: <1189772235.21778.287.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cEr0g5hhZYsZtWF9rWLy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-14 at 14:04 +0200, Roman Zippel wrote:

> AFAICT the compensation part is already done by the scaling part, without=
=20
> the load part it largely mirrors what __update_stats_wait_end() does, i.e=
.=20
> it gets the same time as other tasks, which have been on the rq.

All it tried to do was approximate the situation where the task never
left the rq. I'm not saying it makes sense or is the right thing to do,
just what the thought behind that particular bit was.

There is a reason it was turned off by default:

-		SCHED_FEAT_SLEEPER_AVG		*0 |



--=-cEr0g5hhZYsZtWF9rWLy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG6nvLXA2jU0ANEf4RAjoeAJ9TPlcpgHAGz2/1wcgU8Gjz7Ph5DwCeN3xx
AXs+6bq2eKAnGPnIvKj4C80=
=pW+w
-----END PGP SIGNATURE-----

--=-cEr0g5hhZYsZtWF9rWLy--

