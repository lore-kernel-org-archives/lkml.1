Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0CGBsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 20:48:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53358 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0CGBsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 20:48:36 -0500
Date: Sun, 7 Mar 2010 12:48:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
       Greg Thelen <gthelen@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: please don't apply : bootmem: avoid DMA32 zone by default
Message-Id: <20100307124826.6c70a779.sfr@canb.auug.org.au>
In-Reply-To: <20100307010327.GD15725@brick.ozlabs.ibm.com>
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com>
	<20100305032106.GA12065@cmpxchg.org>
	<49b004811003042117n720f356h7e10997a1a783475@mail.gmail.com>
	<4B915074.4020704@kernel.org>
	<4B916BD6.8010701@kernel.org>
	<4B91EBC6.6080509@kernel.org>
	<20100306162234.e2cc84fb.akpm@linux-foundation.org>
	<20100307010327.GD15725@brick.ozlabs.ibm.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__7_Mar_2010_12_48_26_+1100_OZJqAAANxhscbimK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__7_Mar_2010_12_48_26_+1100_OZJqAAANxhscbimK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Sun, 7 Mar 2010 12:03:27 +1100 Paul Mackerras <paulus@samba.org> wrote:
>
> On Sat, Mar 06, 2010 at 04:22:34PM -0800, Andrew Morton wrote:
> > Earlier, Johannes wrote
> >=20
> > : Humm, now that is a bit disappointing.  Because it means we will never
> > : get rid of bootmem as long as it works for the other architectures.=20
> > : And your changeset just added ~900 lines of code, some of it being a
> > : rather ugly compatibility layer in bootmem that I hoped could go away
> > : again sooner than later.
>=20
> Whoa!  Who's proposing to get rid of bootmem, and why?

I assume that is the point of the "early_res" work already in Linus' tree
starting from commit 27811d8cabe56e0c3622251b049086f49face4ff ("x86: Move
range related operation to one file").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__7_Mar_2010_12_48_26_+1100_OZJqAAANxhscbimK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuTBeoACgkQjjKRsyhoI8xhpACcDObt+kcXskN18effWjz/qp07
NnkAoJp9fYyg3fxv9ru6/yJg5649Y6UK
=2PoU
-----END PGP SIGNATURE-----

--Signature=_Sun__7_Mar_2010_12_48_26_+1100_OZJqAAANxhscbimK--
