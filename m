Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYB2Gno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYB2Gno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYB2Gnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:43:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52763 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYB2Gnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:43:33 -0500
Date: Fri, 29 Feb 2008 17:43:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-Id: <20080229174326.6b649ade.sfr@canb.auug.org.au>
In-Reply-To: <20080228181054.dddcf559.akpm@linux-foundation.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx>
	<1204180441-8540-4-git-send-email-matthew@wil.cx>
	<1204180441-8540-5-git-send-email-matthew@wil.cx>
	<1204180441-8540-6-git-send-email-matthew@wil.cx>
	<1204180441-8540-7-git-send-email-matthew@wil.cx>
	<1204180441-8540-8-git-send-email-matthew@wil.cx>
	<1204180441-8540-9-git-send-email-matthew@wil.cx>
	<1204180441-8540-10-git-send-email-matthew@wil.cx>
	<1204180441-8540-11-git-send-email-matthew@wil.cx>
	<20080228071822.GA13571@elte.hu>
	<20080229003954.GA525@parisc-linux.org>
	<20080229130019.3ede8053.sfr@canb.auug.org.au>
	<20080228181054.dddcf559.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_17_43_26_+1100_IqQYad./n51zH+g2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_17_43_26_+1100_IqQYad./n51zH+g2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Feb 2008 18:10:54 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > I have put this in for toady's build (but using the git URL).  This tree
> > is in the "too many conflicts and its out until fixed" category ...
>=20
> A shame.
>=20
> Most of the conflicts will be due to all the
>=20
> -#include <asm/semaphore.h>
> +#include <linux/semaphore.h>
>=20
> but they're all optional anyway, because include/asm-*/semaphore.h is
>=20
> #include <linux/semaphore.h>
>=20
> so either a) you just ignore all those conflicts or b) we ask Willy to
> remove all that stuff and we can trickle it in via subsystems later.

My conflict tolerance is already rising.  i.e. I will fix up such trivial
to fix conflicts.  I am more concerned with complexity of conflicts than
mere number (so "too many conflicts" should be read as "too many
conflicts that I can't figure out in a shortish period of time").

If it gets too bad, it falls into Linus' "the person who changes the APIs
bears the pain" basket. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Feb_2008_17_43_26_+1100_IqQYad./n51zH+g2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx6mTTgG2atn1QN8RAvSmAJ97lO81SekVLx1e2yAoDqQm4GlKXQCfVUcL
cE3HcGeRZ9SUvP3THJBtyIc=
=rY/a
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_17_43_26_+1100_IqQYad./n51zH+g2--
