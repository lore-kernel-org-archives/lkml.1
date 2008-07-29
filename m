Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYG2IDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYG2IDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYG2IDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:03:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40387 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbYG2ID1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:03:27 -0400
Date: Tue, 29 Jul 2008 18:03:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: build failure
Message-Id: <20080729180317.94c64634.sfr@canb.auug.org.au>
In-Reply-To: <20080729080055.GA28916@elte.hu>
References: <20080729162300.733b3e09.sfr@canb.auug.org.au>
	<20080729080055.GA28916@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_18_03_17_+1000_zO=OK9vmVfW5TShh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_18_03_17_+1000_zO=OK9vmVfW5TShh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 29 Jul 2008 10:00:55 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> > -#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
> > +#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
>=20
> hm, i'm wondering - is this a compiler bug?

Or maybe a deficiency in such an old compiler (v3.4.5) but the fix makes
sense anyway, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_18_03_17_+1000_zO=OK9vmVfW5TShh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiOzsUACgkQjjKRsyhoI8zHFACfT6Uv28/5Y/xQOZa4sEphVVE8
8JMAn1gTootRx/I5maK5VNPM3Mwza0i4
=IFv9
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_18_03_17_+1000_zO=OK9vmVfW5TShh--
