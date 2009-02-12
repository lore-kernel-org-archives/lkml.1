Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbZBLCXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbZBLCXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZBLCX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:23:29 -0500
Received: from ozlabs.org ([203.10.76.45]:37360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbZBLCX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:23:29 -0500
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090212011051.265346435@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oAaTJkePUZ8FTgW4oNZQ"
Date: Thu, 12 Feb 2009 13:23:26 +1100
Message-Id: <1234405406.8142.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oAaTJkePUZ8FTgW4oNZQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 20:10 -0500, Steven Rostedt wrote:
> The following set of patches are RFC and not for inclusion
> (unless everyone is fine with them as is).
>=20
> This is the port to PowerPC of the function graph tracer that was written
> by Frederic Weisbecker for the x86 architecture.  It is broken up
> into a series of logical steps.
>=20
> 1) get generic code ready for other archs
> 2) get PowerPC 64-bit working with just static function tracing
> 3) get PowerPC 64-bit working with dynamic function tracing
> 4) get PowerPC 32-bit working with just static function tracing
> 5) get PowerPC 32-bit working with dynamic function tracing
>=20
> (with some clean ups in between)
>=20
>=20
> The function graph tracer not only traces the start of a function
> (uses the function tracer part for that) but also uses the kprobes
> trick to replace the return address with a hook to trace the exit
> of the function.

You use the "kprobes trick", but none of the kprobes code (AFAICS).
Couldn't there be some common code between the two?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-oAaTJkePUZ8FTgW4oNZQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmTiB4ACgkQdSjSd0sB4dIJ+wCeLIeMLjO0rSCgwvHKt/VMTx63
gdkAnAuZpE4u1Y2IivMa8CSSMbNu10A9
=EoQF
-----END PGP SIGNATURE-----

--=-oAaTJkePUZ8FTgW4oNZQ--

