Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbXGFTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbXGFTTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbXGFTTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:19:17 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:52195 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbXGFTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:19:16 -0400
Message-ID: <468E95AF.4070600@web.de>
Date: Fri, 06 Jul 2007 21:19:11 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: kgdb-bugreport@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: preemption counter havoc on kgdb-taken faults
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<468E4BA5.8010601@imap.cc> <468E8106.8080801@windriver.com> <468E86DF.4050509@web.de> <468E88CE.2060809@windriver.com>
In-Reply-To: <468E88CE.2060809@windriver.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig680B9E813231E8FA485DD71F"
X-Provags-ID: V01U2FsdGVkX1/+ojYWrWtzR/LM0FoCwtYG21Atpz5t3Sg3tZBw
	73jJngCphPJ7/5qcwMvJUYezUG+C2i9ifLs2yDocETewcF6I95
	/ePFptktc=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig680B9E813231E8FA485DD71F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> Jan Kiszka wrote:
>>
>> At this chance... Reminds me that this old issue still seems to be
>> unsolved in current kgdb:
>>
>> http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg00=
442.html
>>
>>
>> I'm only looking at that spot in kgdb right now and /may/ oversee new
>> border conditions elsewhere. But my feeling is there are none.
>>
>> Jan (looking forward to see kgdb merged)
>>
>>  =20
>=20
>=20
> Hi Jan,
>=20
> This issue was fixed in a generic way in the patch set that is in the
> -mm tree.  Had you tried your test case in the current -mm tree?

Nope, I have unfortunately no adequate test setup at hand right now.

>=20
> The problem you mentioned was fixed by saving and restoring the preempt=

> count as a part of the fault handling from the kgdb core and not in the=

> arch specific portion.

Ah, OK, that was the piece I missed.

Then /me is just curious to finally learn why that hack I once proposed
(which unfortunately never received some feedback) is not the right way
to go. In other words, what is the reason for this special
fault_setjmp/fault_longjmp?

Jan


--------------enig680B9E813231E8FA485DD71F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGjpWvniDOoMHTA+kRAvuTAJ9oHH+pVmVuo1eK3f7nJfMA5KvIQQCffSkq
SSGZY/m0qAnPhe7jKUIk2qs=
=V39t
-----END PGP SIGNATURE-----

--------------enig680B9E813231E8FA485DD71F--
