Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZILGxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZILGxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 02:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZILGxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 02:53:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41024 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZILGxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 02:53:04 -0400
Date: Sat, 12 Sep 2009 16:53:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Warning from ring buffer code (Was: Re: linux-next: tip tree build
 warning)
Message-Id: <20090912165300.9d257283.sfr@canb.auug.org.au>
In-Reply-To: <1249403089.4634.139.camel@localhost.localdomain>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	<1249403089.4634.139.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__12_Sep_2009_16_53_00_+1000_JmHg6_AHH_VBQy.O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Sep_2009_16_53_00_+1000_JmHg6_AHH_VBQy.O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Tue, 04 Aug 2009 12:24:49 -0400 Steven Rostedt <srostedt@redhat.com> wro=
te:
>
> On Tue, 2009-08-04 at 16:16 +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next build (powerpc ppc64_defconfig) produced these warni=
ngs:
> >=20
> > kernel/trace/ring_buffer.c: In function 'rb_head_page_set':
> > kernel/trace/ring_buffer.c:704: warning: initialization makes pointer f=
rom integer without a cast
> > kernel/trace/ring_buffer.c:704: warning: initialization makes pointer f=
rom integer without a cast
> > kernel/trace/ring_buffer.c: In function 'rb_head_page_replace':
> > kernel/trace/ring_buffer.c:797: warning: initialization makes integer f=
rom pointer without a cast
> >=20
> > Introduced by commit 77ae365eca895061c8bf2b2e3ae1d9ea62869739
> > ("ring-buffer: make lockless").
>=20
> Thanks, I'll take a look at it.

Now that this is in Linus' tree, can we have a fix for the waning, please?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_Sep_2009_16_53_00_+1000_JmHg6_AHH_VBQy.O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqrRUwACgkQjjKRsyhoI8ypXwCdFzQgJhErDla1/9LB51onZGWG
nLUAn2h9uga9PZstEr/GB4FSLgy+Anrp
=6m+c
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Sep_2009_16_53_00_+1000_JmHg6_AHH_VBQy.O--
