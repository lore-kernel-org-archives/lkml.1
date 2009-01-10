Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZAJOuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZAJOuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZAJOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:50:42 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:40590 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZAJOul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:50:41 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <496663B6.3090709@redhat.com>
References: <49639EB8.40204@redhat.com>	<4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	 <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
	 <20090108143220.GA8717@redhat.com>
	 <20090108193530.99D74FC3DD@magilla.sf.frob.com>
	 <496663B6.3090709@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5CwI9i1KnCHnoxg5RLKz"
Date: Sat, 10 Jan 2009 14:50:41 +0000
Message-Id: <1231599041.11642.57.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5CwI9i1KnCHnoxg5RLKz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 15:36 -0500, Casey Dahlin wrote:

> Roland McGrath wrote:
> >>> Since waitfd shouldn't consume the child termination notification
> >>> waitfd should be more widely usable than the wait*() interfaces.
> >=20
> > waitid can be used that way with WNOWAIT.
>=20
> Yes, but waitfd does not have this flag. The reason being waitfd just
> calls waitid internally, and there is no guarantee (afaik) that
> calling waitid with WNOWAIT multiple times in succession will yield
> different results each time. This breaks the streaming behavior of the
> descriptor.
>=20
This would definitely be a Nice To Have though!

Being able to use waitid() on another process of the same uid, with
WNOHANG, in a streaming fashion would be a *very* cool thing.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-5CwI9i1KnCHnoxg5RLKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklotcEACgkQSnQiFMl4yK6lXwCfXpPp+yuwJ9+M88E2pxps+4wM
fnEAn0LZREFTCa4/XhNT0T5SBsywLz0f
=iW0L
-----END PGP SIGNATURE-----

--=-5CwI9i1KnCHnoxg5RLKz--

