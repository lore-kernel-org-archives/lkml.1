Return-Path: <linux-kernel-owner+w=401wt.eu-S1030916AbXDVO1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030916AbXDVO1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030915AbXDVO1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:27:55 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:56619 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030911AbXDVO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:27:54 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 16:27:26 +0200
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Willy Tarreau <w@1wt.eu>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
References: <200704221441.48897.kernel@kolivas.org> <200704222142.52325.kernel@kolivas.org> <200704222218.32754.kernel@kolivas.org>
In-Reply-To: <200704222218.32754.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10154531.18sA1NCR7G";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704221627.42788.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177252074;45a24faf;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10154531.18sA1NCR7G
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Anyway the more important part is... Can you test this patch please? Dump
> all the other patches I sent you post 045. Michael, if you could test too
> please?

Have it up running for 40 minutes now and my perljobs show a constant
cpu utilization of 100/50/50 in top most of the time. When the 100% job
goes down to e.g. 70% these 30% are immediately reclaimed by the other
two, i.e. the total sum of all three stays with 2% point of 200%.

=46rom here it seems as if your latest patch did what is was supposed to :-)

Best,
Michael

PS: While these numbercrunching jobs were running I started another
kde session and have my children play supertux for 20 minutes. While
the system occasionally was not as responsive as it is when there
is little load, supertux remained very playable.
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart10154531.18sA1NCR7G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGK3DeUYYhyuxDQc4RAj0rAJ9VjMoN/o8q57u5VE9ZbKcpG2kf4wCfePVA
XcJe+cdqyFrzOauDGqfQt60=
=Ik2R
-----END PGP SIGNATURE-----

--nextPart10154531.18sA1NCR7G--
