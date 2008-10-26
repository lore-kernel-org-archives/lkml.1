Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYJZLxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYJZLxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYJZLxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:53:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41464 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYJZLxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:53:33 -0400
Date: Sun, 26 Oct 2008 22:53:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Message-Id: <20081026225324.6231397d.sfr@canb.auug.org.au>
In-Reply-To: <10752.1225019273@redhat.com>
References: <20081025130851.379cfac0.sfr@canb.auug.org.au>
	<20081024174838.GA24466@us.ibm.com>
	<11290.1224873841@redhat.com>
	<10752.1225019273@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__26_Oct_2008_22_53_24_+1100_2zkpqZB5CY/VAqNc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__26_Oct_2008_22_53_24_+1100_2zkpqZB5CY/VAqNc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Sun, 26 Oct 2008 11:07:53 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > It would be good if you could have a "next" (or "creds-next" or
> > something) branch in your tree and I can fetch that (that way I don't
> > have to keep updating my configs).  It is OK if thet branch rebases and
> > may just be an alias for another branch (or a subset if you have
> > experimental stuff in there.  Remember "posted, reviewed, tested before
> > it is in linux-next".
>=20
> Those patches aren't likely to change much, and they get hit with LTP
> regularly.

They already changed between what I thought was the correct branch and
what was the correct branch :-)

> What base for the patches?  Linus's head?

Yes. Or whatever it is based on now if that merges OK with Linus' head
(try a test merge).  Just don't base on linux-next :-)

What I want is exactly what you will ask/have asked Linus to fetch but
without the branch name changing .. I care more about the name changing
than the contents changing.

So .. what branch do I fetch tomorrow?  (Hint: if you have your version
for Linus checked out then type "git branch next" and reply to this email
saying "next" :-))
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__26_Oct_2008_22_53_24_+1100_2zkpqZB5CY/VAqNc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkEWjQACgkQjjKRsyhoI8xvsACfTj6fUvVuqVXT++Uld155sT8s
q30AnRnaxu6JNQ43Dd5fY9CyHTnvNacW
=J7hb
-----END PGP SIGNATURE-----

--Signature=_Sun__26_Oct_2008_22_53_24_+1100_2zkpqZB5CY/VAqNc--
