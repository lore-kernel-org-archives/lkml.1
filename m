Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZAJOwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZAJOwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZAJOwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:52:21 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:40601 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZAJOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:52:20 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Casey Dahlin <cdahlin@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090108213901.GA26729@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	 <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
	 <20090108143220.GA8717@redhat.com>
	 <20090108193530.99D74FC3DD@magilla.sf.frob.com>
	 <496663B6.3090709@redhat.com>  <20090108213901.GA26729@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VJ7hq0uFXAbUEfulUsPf"
Date: Sat, 10 Jan 2009 14:52:21 +0000
Message-Id: <1231599141.11642.58.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VJ7hq0uFXAbUEfulUsPf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 22:39 +0100, Oleg Nesterov wrote:

> Btw. It is not that I am trying to argue against sys_waitfd(), but do
> you have the "real life" example when it can be useful? Yes, poll().
> But we have signalfd. SIGCHLD is not rt signal, but afaics this is not
> the problem actually. Just curious.
>=20
signalfd() can't currently be made to work in the way you describe.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-VJ7hq0uFXAbUEfulUsPf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklotiUACgkQSnQiFMl4yK6uPgCdF+HRO9NIRCjt6yfhYnLEezIk
oTkAnjYsnCXXj3KjEVgBzOo0939Nfxka
=a1ns
-----END PGP SIGNATURE-----

--=-VJ7hq0uFXAbUEfulUsPf--

