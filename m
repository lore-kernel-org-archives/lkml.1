Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXEWFX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXEWFX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 01:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbXEWFXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 01:23:49 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:40146 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271AbXEWFXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 01:23:49 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Date: Wed, 23 May 2007 07:23:23 +0200
User-Agent: KMail/1.9.7
Cc: Bill Davidsen <davidsen@tmr.com>, Miguel Figueiredo <elmig@debianpt.org>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <464F57DD.2000309@tmr.com> <46538AB8.8030009@tmr.com> <200705241036.45179.kernel@kolivas.org>
In-Reply-To: <200705241036.45179.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1327352.rJZYgpno7r";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705230723.42400.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1179897828;1644d024;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1327352.rJZYgpno7r
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> That's because the whole premise of your benchmark relies on a workload t=
hat=20
> yield()s itself to the eyeballs on most graphic card combinations when us=
ing=20
> glxgears. Your test remains a test of sched_yield in the presence of your=
=20
> workloads rather than anything else. If people like ck2 it's because in t=
he=20
> real world with real workloads it is better, rather than on a yield() bas=
ed=20
> benchmark. Repeatedly the reports are that 3d apps and games in normal us=
age=20
> under -ck are better than mainline and cfs.

While I can't comment on the technical/implementational details of
Con's claim I definitely have to agree from a users POV.

All my recent CPU intensive benchmarks show that both ck/sd and cfs
are very decent scheduler and IMO superior to mainline for all _my_
usecases. In particular playing supertux while otherwise fully utilizing
both CPUs on a dualcore works without any glitch and better than
on mainline for both sd and cfs.

=46or me the huge difference you have for sd to the others increases the
likelyhood the glxgears benchmark does not measure scheduling of graphic
but something else.

Anyway, I'm still in the process of collecting data or more precisely
until recently constantly refined what data to collect and how. I plan
to provide new benchmark results on CPU intensive tasks in a couple of
days.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1327352.rJZYgpno7r
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGU8/eUYYhyuxDQc4RApjgAJ9poSqoCC/FrNjRsZ9CFVWT3kYK2QCfS03P
jOsWPiTp2Unp69fUDbXfYGg=
=RdpB
-----END PGP SIGNATURE-----

--nextPart1327352.rJZYgpno7r--
