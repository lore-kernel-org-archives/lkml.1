Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXDZGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXDZGp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXDZGp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:45:28 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53453 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbXDZGp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:45:26 -0400
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
In-Reply-To: <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xnLf079A8XArn3c0in3I"
Date: Thu, 26 Apr 2007 08:27:07 +1000
Message-Id: <1177540027.5025.87.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xnLf079A8XArn3c0in3I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 15:18 -0700, Linus Torvalds wrote:
>=20
> On Wed, 25 Apr 2007, Pavel Machek wrote:
> >=20
> > Not the same... but they are still related. "freeze" (for atomic
> > snapshot) is actually subset of "suspend"... freeze needs DMAs off and
> > saved state, and you need DMAs off and saved state for "suspend".
>=20
> THEY HAVE ABSOLUTELY NOTHING IN COMMON!
>=20
> Nobody in their right mind thinks that "disable DMA" and "suspend" are=20
> similar operations.=20
>=20
> > So it is actually correct to do "suspend" when you want "freeze"; it
> > is just slow. That's why they only differ in parameter these days.
>=20
> It is *not* correct to "suspend" when you want "freeze".
>=20
> I don't understand how you can even *claim* something like that.
>=20
> Here's a trivial example:
>  - SCSI disk
>=20
> Tell me, what does "suspend" do, and what does "freeze" (snapshot) do?
>=20
> And name *one* thing that have in common.

Set/reset the scsi transaction id thingy? Hibernation didn't work with
SCSI for a long time precisely because that support was missing.

Don't get me wrong, I agree on the whole - Suspend2 worked fine on the
whole under 2.4 without a driver model. But they do have a bit in
common.

Regards,

Nigel

--=-xnLf079A8XArn3c0in3I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGL9W7N0y+n1M3mo0RAp2aAKCBpvIPtjm7XShf2wf+XVxDF6a3CgCdG9kI
bX+QQepHH4K75HqtylXurYM=
=Q5BJ
-----END PGP SIGNATURE-----

--=-xnLf079A8XArn3c0in3I--

