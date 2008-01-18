Return-Path: <linux-kernel-owner+w=401wt.eu-S1765066AbYARTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765066AbYARTC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760290AbYARTCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:02:19 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33367 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758982AbYARTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:02:18 -0500
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
From: Zan Lynx <zlynx@acm.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4790E3A6.7060807@linux.intel.com>
References: <4790E3A6.7060807@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AdzP9TQIAZ3JQNwsTAhi"
Date: Fri, 18 Jan 2008 12:02:11 -0700
Message-Id: <1200682931.7735.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080118/1JFwTl-0005UX-F0-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AdzP9TQIAZ3JQNwsTAhi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-01-18 at 09:36 -0800, Arjan van de Ven wrote:
> The Intel Open Source Technology Center is pleased to announce the
> release of version 0.1 of LatencyTOP, a tool for developers to visualize
> system latencies.
>=20
> http://www.latencytop.org
>=20
> Slow servers, Skipping audio, Jerky video --everyone knows the symptoms
> of latency. But to know what's really going on in the system, what's caus=
ing
> the latency, and how to fix it... those are difficult questions without
> good answers right now.
[cut]

Just curious...

My biggest latency problems (as observed by me, the user) happen when a
program needs memory, or launching a new program, and the kernel begins
forces dirty memory to disk.  This results in an unholy seek storm of
mixed writes (flushing, maybe a little swap) and reads (new program
loading).  Streaming audio/video almost always starts freezing up during
this as well.

I don't suppose LatencyTop would help track anything down in that case,
would it?
--=20
Zan Lynx <zlynx@acm.org>

--=-AdzP9TQIAZ3JQNwsTAhi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHkPezG8fHaOLTWwgRAoP9AJ9joxVG/1hOzEl5lhYNx6KsgLz/2wCgjviM
jbg9aeI1y5/z7CS6Hh0KnI8=
=kZD8
-----END PGP SIGNATURE-----

--=-AdzP9TQIAZ3JQNwsTAhi--

