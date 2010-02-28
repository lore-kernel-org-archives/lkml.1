Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031477Ab0B1Hhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:37:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51621 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031422Ab0B1Hhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:37:33 -0500
Date: Sun, 28 Feb 2010 18:37:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-Id: <20100228183725.80915681.sfr@canb.auug.org.au>
In-Reply-To: <20100228071405.GA14205@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<201002271323.14402.rjw@sisk.pl>
	<20100227124710.GA21164@elte.hu>
	<201002272007.43042.rjw@sisk.pl>
	<20100228071405.GA14205@elte.hu>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_18_37_25_+1100_xWoEhv3XK9rkg2qL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Feb_2010_18_37_25_+1100_xWoEhv3XK9rkg2qL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Sun, 28 Feb 2010 08:14:05 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> > [...]  As long as that's the case, linux-next should build on them too.
>=20
> No, and IMO linux-next is clearly over-interpreting this bit. Linux is no=
t=20
> supposed to build on all architectures. Maybe that's a core bit of a=20
> misunderstanding (on either my or on sfr's side) and it should be clarifi=
ed=20
> ...

Well, we have no real problem then.  The only architectures for which a
failure will stop new stuff getting into linux-next are the ones I
personally build while constructing the tree (x86, ppc and sparc).  Once
something is in linux-next, even if it causes a build failure overnight,
I am loath to remove it again as it can cause pain for Andrew (who bases
-mm on linux-next).

I will still report such failures (if I have time to notice them - I
mostly hope that architecture maintainers will have a glance over the
build results themselves) and others do as well but such failures do not
generally cause any actions on my part (except in rare cases I may
actually fix the problem or put a provided fix patch in linux-next).

I would like to add arm to the mix of the architectures I build during
construction, but there is no wide ranging config that builds for arm and
building a few of the configs would just end up taking too much time.

Thanks for clarifying.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__28_Feb_2010_18_37_25_+1100_xWoEhv3XK9rkg2qL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuKHTUACgkQjjKRsyhoI8zYGwCfQojFzWOfdw3aI7S5cqIxcWv2
HgMAniY1x5IY4oO42pgvWVqiz3zJcdTF
=cQRw
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_18_37_25_+1100_xWoEhv3XK9rkg2qL--
