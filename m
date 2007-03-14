Return-Path: <linux-kernel-owner+w=401wt.eu-S933892AbXCNIUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbXCNIUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 04:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933889AbXCNIUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 04:20:39 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:37061 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750763AbXCNIUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 04:20:38 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Zan Lynx <zlynx@acm.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45F79B9C.20609@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>
	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tDnMPSDYevmWWN1x3n5s"
Date: Wed, 14 Mar 2007 02:20:32 -0600
Message-Id: <1173860432.12305.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tDnMPSDYevmWWN1x3n5s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-13 at 23:52 -0700, Jeremy Fitzhardinge wrote:
> Yep.  But the tsc is just an example of a clocksource, and doesn't have
> any real bearing on what I'm saying.
[cut/snip/slash]
> Well, it doesn't need to be a constant clock if its modelling a changing
> rate.  And it doesn't need to be an exact model; it just needs to be
> better than the current situation.

It's 2 AM so I don't know if I'm making sense, but I had an idea for the
sort of clock I think you're looking for.

Couldn't one of the CPU performance counters do this?  I think you can
set one to count cycles and trigger every 100,000, or 10,000 or 1,000,
or whatever.  Then when you get that interrupt hit the context switch.

Then every time slice would be in cycles and not wall-clock, which is
what I think you wanted.
--=20
Zan Lynx <zlynx@acm.org>

--=-tDnMPSDYevmWWN1x3n5s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBF97BQG8fHaOLTWwgRAo6VAJ9fF5vf+gjnmwWM3tM4Xzjm2JCONgCglXg4
aMVENU4jc0TWV59PGL+xFw8=
=z4Ev
-----END PGP SIGNATURE-----

--=-tDnMPSDYevmWWN1x3n5s--

