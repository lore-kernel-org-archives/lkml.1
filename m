Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZAJOJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZAJOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZAJOJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:09:20 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:60879 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZAJOJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:09:20 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i7n8mx6ekvPdzxOy31Dq"
Date: Sat, 10 Jan 2009 14:09:25 +0000
Message-Id: <1231596565.11642.24.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i7n8mx6ekvPdzxOy31Dq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 12:53 -0800, Roland McGrath wrote:

> New syscall should have gone to linux-api, I think.
>=20
> Do we really need another one for this?  How about using signalfd plus
> setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead =
of
> SIGCHLD?  It's slightly more magical for the userland process to know to =
do
> that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
> really have to add, maybe better.
>=20
Doesn't that also change the wait() options you need as well?

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-i7n8mx6ekvPdzxOy31Dq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklorBUACgkQSnQiFMl4yK7t5ACfWiDhhgZZSFALlQL3f0/MfTa7
Us0AnjpUb4Um86frtgoPeZW4X510VX4Y
=L3v+
-----END PGP SIGNATURE-----

--=-i7n8mx6ekvPdzxOy31Dq--

