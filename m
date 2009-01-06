Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZAFNHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZAFNHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZAFNHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:07:37 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40379 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZAFNHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:07:36 -0500
Message-ID: <4963584A.4090805@novell.com>
Date: Tue, 06 Jan 2009 08:10:34 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
In-Reply-To: <20090106121052.GA27232@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig13FC11A962D1BDDF958F15C6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig13FC11A962D1BDDF958F15C6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> There's no time or spin-rate based heuristics in this at all (i.e. thes=
e=20
> mutexes are not 'adaptive' at all!),

FYI: The original "adaptive" name was chosen in the -rt implementation
to reflect that the locks can adaptively spin or sleep, depending on
conditions.  I realize this is in contrast to the typical usage of the
term when it is in reference to the spin-time being based on some
empirical heuristics, etc as you mentioned.  Sorry for the confusion.

Regards,
-Greg


--------------enig13FC11A962D1BDDF958F15C6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkljWEoACgkQlOSOBdgZUxn72ACfS2VJ9HA2Q3Ud+FqozlY40nMI
+EYAn0l0nsRQfX7uZlf6PYlqYL9fGuNb
=hQ/V
-----END PGP SIGNATURE-----

--------------enig13FC11A962D1BDDF958F15C6--
