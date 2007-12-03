Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXLCNlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXLCNlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXLCNlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:41:42 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:49829 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXLCNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:41:41 -0500
Date: Mon, 3 Dec 2007 14:41:28 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203144128.16a3dd53@astralstorm.puszkin.org>
In-Reply-To: <20071203132955.GA31354@elte.hu>
References: <20071203111520.33ed2139@astralstorm.puszkin.org>
	<20071203102715.GC28560@one.firstfloor.org>
	<20071203103815.GA2707@elte.hu>
	<20071203110412.GD28560@one.firstfloor.org>
	<20071203115900.GB8432@elte.hu>
	<20071203121357.GB2986@one.firstfloor.org>
	<20071203122833.GA20232@elte.hu>
	<20071203124144.GC2986@one.firstfloor.org>
	<20071203130003.GA26372@elte.hu>
	<20071203131442.GA4004@one.firstfloor.org>
	<20071203132955.GA31354@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mUFZOCJfy3GPyg3=cJuBwE.";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mUFZOCJfy3GPyg3=cJuBwE.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Dec 2007 14:29:56 +0100
> * Andi Kleen <andi@firstfloor.org> wrote:
>=20
> > > feedback about an impending catastrophy has been duly noted
> >=20
> > The point was less about an impending catastrophe, but more of a=20
> > timebomb ticking until the next widely used release.

I think I know why Andi is so much against backtraces: he has some log
filter listening on netconsole mailing him with suspicious log messages.

Apparently, that log filter is much too stupid to discern an
OOPS or OOM from softlockup and other informative backtraces even when
given a clear hint what it is.

Or maybe he's just underestimating user's ability to read. ;)

--Sig_/mUFZOCJfy3GPyg3=cJuBwE.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHVAePBlhXA0ALOYMRAv2ZAJ9cb1dftm1NMtRFy8m/h4N3c7uqDwCeMJSR
DWqR1a8nkUqY0DG2EnE0O4M=
=Xgva
-----END PGP SIGNATURE-----

--Sig_/mUFZOCJfy3GPyg3=cJuBwE.--
