Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXDZLBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXDZLBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXDZLBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:01:09 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbXDZLBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:01:07 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Nick Piggin <npiggin@suse.de>,
       suspend2-devel@lists.suspend2.net, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IlGzXTFZf60XfRRSMp99"
Date: Thu, 26 Apr 2007 12:39:58 +0200
Message-Id: <1177583998.6814.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IlGzXTFZf60XfRRSMp99
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-25 at 15:55 -0700, Linus Torvalds wrote:

> That's where I started: whole "suspend to disk" thing actually has _more_=
=20
> to do with "shutdown" than with "suspend".=20

=46rom looking at pm_ops which I was recently working with a lot, it seems
that it was designed by somebody who was reading the ACPI documentation
and was otherwise pretty clueless, even at that level std tries to look
like suspend. IMHO that is one of the first things that should be ripped
out, no pm_ops for STD, it's a pain to work with.

johannes

--=-IlGzXTFZf60XfRRSMp99
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMIF+/ETPhpq3jKURAutsAJ93vRXClZER1VeZiaPlW7Kr8lzEgwCfcj9g
ENyA5A/H+5JRXY/YOiJSMPs=
=qhHq
-----END PGP SIGNATURE-----

--=-IlGzXTFZf60XfRRSMp99--

