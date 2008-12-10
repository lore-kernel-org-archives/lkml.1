Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYLJQUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYLJQUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYLJQU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:20:26 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:43342 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYLJQUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:20:25 -0500
Message-ID: <493FED0D.4080204@novell.com>
Date: Wed, 10 Dec 2008 11:23:41 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH][RT] Compile-time fix.
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>  <1228890920.9542.2.camel@dd> <1228892002.9542.4.camel@dd> <alpine.DEB.1.10.0812100643130.5912@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812100643130.5912@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig59C3C706CD6F66FA49A796D4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59C3C706CD6F66FA49A796D4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
>
> If you do want to help, look at any of the other branches. Some have no=
t=20
> been updated yet, and they all should be able to compile and boot on th=
eir=20
> own. If they do not, then those need to be fixed.
>  =20

A good place to start for some low-hanging fruit would be rt/workqueue.=20
I ported the patches, but it doesn't yet boot (assuming Steve merged the
work I had done...I havent looked recently).  I think its a relatively
trivial problem, but I have not had a chance to track it down yet.

-Greg



--------------enig59C3C706CD6F66FA49A796D4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkk/7Q0ACgkQlOSOBdgZUxmiiQCdFWxK5qJ18i2pwWaV3ujpahQJ
YSMAn0F+V002UcXNZd/aQJTezOSpPjit
=JlkL
-----END PGP SIGNATURE-----

--------------enig59C3C706CD6F66FA49A796D4--
