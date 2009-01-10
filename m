Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZAJRKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZAJRKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 12:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZAJRJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 12:09:59 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:42818 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 12:09:58 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Casey Dahlin <cdahlin@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090110161911.GB10954@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	 <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
	 <20090108143220.GA8717@redhat.com>
	 <20090108193530.99D74FC3DD@magilla.sf.frob.com>
	 <496663B6.3090709@redhat.com> <20090108213901.GA26729@redhat.com>
	 <1231599141.11642.58.camel@quest>  <20090110161911.GB10954@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IRIpMwVF5YhSsAnwW5sx"
Date: Sat, 10 Jan 2009 17:09:58 +0000
Message-Id: <1231607398.11642.104.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IRIpMwVF5YhSsAnwW5sx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 17:19 +0100, Oleg Nesterov wrote:

> I am not sure we are talking about the same thing, but afaics poll() +
> signalfd can work to (say) reap the childs. Actually, ppoll() alone is
> enough.
>=20
Last time I checked, ppoll() was not actually implemented across all
architectures in a manner that solved the race it was intended to solve.

I'd be delighted to learn that this had been fixed? :-)

Soctt
--=20
Scott James Remnant
scott@canonical.com

--=-IRIpMwVF5YhSsAnwW5sx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklo1mYACgkQSnQiFMl4yK6QDACeM5Vi/kSnn591GHmDI0uZt9Iw
s10An1epTeNn2X3EmqC7ADns+aNlqGXK
=Q0Ju
-----END PGP SIGNATURE-----

--=-IRIpMwVF5YhSsAnwW5sx--

