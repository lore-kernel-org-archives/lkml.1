Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbXJAAoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbXJAAoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 20:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXJAAoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 20:44:25 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:47979 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXJAAoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 20:44:24 -0400
Date: Mon, 1 Oct 2007 02:44:17 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Message-ID: <20071001024417.3478c2be@laptop.hypervisor.org>
In-Reply-To: <200710010207.34430.elendil@planet.nl>
References: <200709282225.21530.elendil@planet.nl>
	<200709302350.30612.elendil@planet.nl>
	<20071001000037.475473bd@laptop.hypervisor.org>
	<200710010207.34430.elendil@planet.nl>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/giKZfJw.fkKH3CQpFc9q+/c";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/giKZfJw.fkKH3CQpFc9q+/c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Oct 2007 02:07:33 +0200 Frans Pop (FP) wrote:

FP> On Monday 01 October 2007, you wrote:
FP> > I was suggesting to download 2.6.23-rc8 and applying the -hrt patchset
FP> > at
FP> > http://www.kernel.org/pub/linux/kernel/people/tglx/hrtimers/2.6.23-rc=
8/
FP> > on top of it.
FP>=20
FP> Ah, OK. I'm afraid that was not at all clear from your previous
FP> message :-/

Yeah, sorry about that.

FP> During 'make oldconfig' I got a config question about "CPU idle
FP> support", which does not seem to be in rc8-mm2; is that correct? I
FP> answered N.

Shouldn't matter either way. Answering 'Y' gives you a more sophisticated
C-state governor that improves battery life.

FP> The system does boot with rc8 + hrt1.

Good. That seems to confirm my suspicion that the real problem is caused by
something in -mm which is not in -hrt. However, I have no idea what exactly
could be going wrong.

FP> Andrew: any suggestions on how to trace the "real" culprit for the hang?
FP>=20
FP>=20
FP> Udo: I did see one issue during boot with this rc8 + hrt1 kernel.
FP>      System is Debian unstable.
FP> Setting the system clock..
FP> select() to /dev/rtc to wait for clock tick timed out

Thomas and Andrew are the best people to ask about what exactly has been
merged from -hrt into -mm. Maybe they can chime in here.

Cheers,

	- Udo

--Sig_/giKZfJw.fkKH3CQpFc9q+/c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHAELhnhRzXSM7nSkRAkznAJ9lIhcbRzbFDOKTEkZrkFUwttTFqgCeLb+J
cw5bvFEASngSzkqtOqoasLw=
=cDlY
-----END PGP SIGNATURE-----

--Sig_/giKZfJw.fkKH3CQpFc9q+/c--
