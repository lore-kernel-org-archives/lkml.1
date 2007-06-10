Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXFJJoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXFJJoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXFJJny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:43:54 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54363 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXFJJnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:43:53 -0400
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070610092446.588014600@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092446.588014600@inhelltoy.tec.linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yq87uZKNGiQcpRFLRLfD"
Date: Sun, 10 Jun 2007 19:43:52 +1000
Message-Id: <1181468632.30155.36.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yq87uZKNGiQcpRFLRLfD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Thomas.

On Sun, 2007-06-10 at 09:44 +0000, Thomas Gleixner wrote:
> plain text document attachment (clockevents-fix-resume-logic.patch)
> We need to make sure, that the clockevent devices are resumed, before
> the tick is resumed. The current resume logic does not guarantee this.
>=20
> Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
> event devices before resuming the tick / oneshot functionality.
>=20
> Fixup the existing users.

What are the implications of the issue for current (i386) users? (Could
suspend/hibernation be broken in any way without this patch?)

Regards,

Nigel

--=-yq87uZKNGiQcpRFLRLfD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGa8fYN0y+n1M3mo0RApLQAKCXPeGz1IPyaghZLaD39vBdd4/niACfQJiI
AdXLwCjcHr6gn7LS+5coJvc=
=le0P
-----END PGP SIGNATURE-----

--=-yq87uZKNGiQcpRFLRLfD--

