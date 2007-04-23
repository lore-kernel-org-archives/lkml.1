Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbXDWNwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbXDWNwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbXDWNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:52:18 -0400
Received: from attic.omnifarious.org ([216.254.16.17]:36119 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbXDWNwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:52:17 -0400
Date: Mon, 23 Apr 2007 06:52:16 -0700
From: Eric Hopper <hopper@omnifarious.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
Message-ID: <20070423135216.GA2744@omnifarious.org>
References: <20070423020046.GA28477@omnifarious.org> <462C2E5B.1080008@redhat.com> <Pine.LNX.4.64.0704230353000.25153@server.thyself> <462C4858.3050006@redhat.com> <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself> <20070423010445.454eda63.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20070423010445.454eda63.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 23, 2007 at 01:04:45AM -0700, Andrew Morton wrote:
> The namesys engineers continue to maintain reiser4 and I continue to
> receive patches for it.
>=20
> Right now I'd say that the main blockages for reiser4 are a) the develope=
rs
> aren't presently asking for inclusion (afaik) and b) lack of reviewing
> effort from other kernel developers. =20

If someone else started asking for it to be included and responded to
requests for the various code changes required to increase its quality
to the required level, wouldn't that be enough?  Basically, if someone
forked it.

Or does it specifically have to be namesys engineers?

Oh, two things really interest me about Reiser4.  First, I despise
having to care about how many tiny files I leave lying around when
writing a program.  Berkeley DB and its ilk are evil, evil programs that
obscure data and make things harder.  Secondly, the moves Reiser4 has
made towards having actual transactions at the filesystem level also
intrigue me.

I want to use the filesystem as a DB.  IMHO, there is no reason that
filesystems shouldn't be a DB sans query language.  If there were a more
DB-like way to deal with filesystems, I think that it would be that much
easier to make something that was a decent replacement for NFS and
actually worked.

Sadly, unless someone pays me to maintain it, I can't do the fork
myself, and I likely wouldn't anyway as being a kernel hacker of
something as important as a filesystem is a full-time job and I have
other things that interest me a lot more.

Just curious,
--=20
Eric Hopper (http://www.omnifarious.org/~hopper/)

--DocE+STaALJfprDB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGLLoQjtsvlOwvazYRAuhTAJ4w97b6aySVSGigJ1qkr5Q1TFyFzACcCUuo
s0Q5La2pBJTTRIXuNy5TDIo=
=NtE0
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
