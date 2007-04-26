Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXDZHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXDZHSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXDZHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:18:46 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57825 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXDZHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:18:45 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz>
	 <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	 <20070425202741.GC17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	 <20070425214420.GG17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	 <1177540027.5025.87.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
	 <1177551601.5025.131.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vK5cjDr/MbNozpucR6zy"
Date: Thu, 26 Apr 2007 12:31:51 +1000
Message-Id: <1177554711.5025.168.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vK5cjDr/MbNozpucR6zy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

Hmm. Perhaps I should have added to that last reply that recognising
that they store similar information doesn't mean I think they need the
same high-level routine for both state transitions.

I'd really like to see each driver have some sort of state machine
controlling its power management, into which these calls were just
another input (an important one, but just another alongside information
about policy, whether we're on battery (UPS or laptop) or AC, whether
the device is actually being used and so on.

Nigel

--=-vK5cjDr/MbNozpucR6zy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMA8XN0y+n1M3mo0RAn5LAKDqKVwMbZajkGhEmGcdcAAteFJu8ACgpkoQ
awCfbfReRpPTFpIyHmr4ZUA=
=kBjp
-----END PGP SIGNATURE-----

--=-vK5cjDr/MbNozpucR6zy--

