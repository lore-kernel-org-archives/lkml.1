Return-Path: <linux-kernel-owner+w=401wt.eu-S1031068AbXDSBw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031068AbXDSBw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031055AbXDSBw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:52:59 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:35675 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031065AbXDSBw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:52:58 -0400
Subject: Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070418220228.GA14536@elte.hu>
References: <20070413202100.GA9957@elte.hu>
	 <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de>  <20070418220228.GA14536@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YbP/YtG+oADPCxklN5Ro"
Date: Thu, 19 Apr 2007 11:52:56 +1000
Message-Id: <1176947576.5906.21.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YbP/YtG+oADPCxklN5Ro
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-19 at 00:02 +0200, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
>=20
> > > although probably your suspend2 problem is still not fixed, it's=20
> > > worth a try nevertheless. Which suspend2 patch did you apply, and=20
> > > was it against -rc6 or -rc7?
> >=20
> > You are right again. ;-)
> >=20
> > Linux 2.6.21-rc7
> > Suspend2 2.2.9.11 (applies cleanly to -rc7)
> > CFS v3 (without any additional patches)
> >=20
> > And it still hangs on suspend.
>=20
> what's the easiest way for me to try suspend2? Apply the patch, reboot=20
> into the kernel, then execute what command to suspend? (there's a=20
> confusing mismash of initiators of all the suspend variants. Can i drive=20
> this by echoing to /sys/power/state?)

=46rom subsequent emails, I think you already got your answer, but just in
case...

Yes, if you enabled "Replace swsusp by default" and you already had it
set up for getting swsusp to resume. If not, and you're using an
initrd/ramfs, you'll need to modify it to echo
> /sys/power/suspend2/do_resume after /sys and /proc are mounted but
prior to mounting / and so on.

Regards,

Nigel

--=-YbP/YtG+oADPCxklN5Ro
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJst4N0y+n1M3mo0RAsycAKDNi7oYH3c8zSeBtsiB0OFlE89VBwCcDVWh
la+JROBvVa7h6M6jTPDAu+Q=
=BvPv
-----END PGP SIGNATURE-----

--=-YbP/YtG+oADPCxklN5Ro--

