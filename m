Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZKKVjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZKKVjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbZKKVjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:39:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36164 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbZKKVjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:39:17 -0500
Date: Thu, 12 Nov 2009 08:39:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, peterz@infradead.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build failure
Message-Id: <20091112083919.82ee89a1.sfr@canb.auug.org.au>
In-Reply-To: <20091112000258F.fujita.tomonori@lab.ntt.co.jp>
References: <20091111201302.da1bab60.sfr@canb.auug.org.au>
	<20091112000258F.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_08_39_19_+1100_QqttgAfjeuvPbN.G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_08_39_19_+1100_QqttgAfjeuvPbN.G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 12 Nov 2009 00:03:28 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt=
.co.jp> wrote:
>
> Duh, sorry about it. I should have complied that patchset for POWERPC
> too. POWERPC has swiotlb but it doesn't expect it to be used (POWERPC
> can remove it).
>=20
> I think that the following patch works. I'll do more cleanup related
> with x86 IOMMU initialization soon (I'm at JFK to go back to Japan).

Great, thanks for the fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_08_39_19_+1100_QqttgAfjeuvPbN.G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7LwcACgkQjjKRsyhoI8yu7wCdEeJN0X6Oc+88WL8eVyvhFxjk
yYgAoJMnp5tAjtSb7n5ermcsbvUCA7mL
=QbgS
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_08_39_19_+1100_QqttgAfjeuvPbN.G--
