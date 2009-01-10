Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZAJSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZAJSqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZAJSqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:46:07 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:52554 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZAJSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:46:06 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Casey Dahlin <cdahlin@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090110182155.GA17516@redhat.com>
References: <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	 <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
	 <20090108143220.GA8717@redhat.com>
	 <20090108193530.99D74FC3DD@magilla.sf.frob.com>
	 <496663B6.3090709@redhat.com> <20090108213901.GA26729@redhat.com>
	 <1231599141.11642.58.camel@quest> <20090110161911.GB10954@redhat.com>
	 <1231607398.11642.104.camel@quest>  <20090110182155.GA17516@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7O3EC522+A9KmGqkt41L"
Date: Sat, 10 Jan 2009 18:46:04 +0000
Message-Id: <1231613164.11642.108.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7O3EC522+A9KmGqkt41L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 19:21 +0100, Oleg Nesterov wrote:

> On 01/10, Scott James Remnant wrote:
> >
> > On Sat, 2009-01-10 at 17:19 +0100, Oleg Nesterov wrote:
> >
> > > I am not sure we are talking about the same thing, but afaics poll() =
+
> > > signalfd can work to (say) reap the childs. Actually, ppoll() alone i=
s
> > > enough.
> > >
> > Last time I checked, ppoll() was not actually implemented across all
> > architectures in a manner that solved the race it was intended to solve=
.
> >
>=20
> As I said, this is imho unfair. But I mentioned ppol() "just in case".
>=20
> My questiong was why do you think that "signalfd() can't currently be
> made to work in the way you describe". You have dropped this part to
> change the topic?
>=20
Sorry, I may not be following LKML etiquette correctly.  These couple of
recent threads (other than some bugs I found in wait last year) are my
first real attempt to participate here.

I wasn't intending to "change the topic" or dropping the parts about
changing signalfd() to somehow sweet it under the carpet.

Rather than posting repeatedly across the thread, I tried to consolidate
my responses into the other post you've replied to.


You made an interesting point about ppoll here, so I only responded to
that to find out whether the situation of that syscall had been
improved.

Not so much changing the topic, but asking a side-bar question ;)

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-7O3EC522+A9KmGqkt41L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklo7OwACgkQSnQiFMl4yK4g4gCeMD7qr+KFuVjN1R0+Yqv8K6DM
VpkAoKXyDb3nml6xRG3s9nFvjR0DU0bk
=5hSK
-----END PGP SIGNATURE-----

--=-7O3EC522+A9KmGqkt41L--

