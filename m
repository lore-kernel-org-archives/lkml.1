Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYG1APt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYG1APt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYG1APl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:15:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbYG1APl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:15:41 -0400
Date: Mon, 28 Jul 2008 10:15:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Karsten Keil <kkeil@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-Id: <20080728101533.beb1250d.sfr@canb.auug.org.au>
In-Reply-To: <20080727182709.1dac0556@lxorguk.ukuu.org.uk>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
	<20080727182709.1dac0556@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Jul_2008_10_15_33_+1000_GNfKP+ALpr7twsJe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jul_2008_10_15_33_+1000_GNfKP+ALpr7twsJe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Jul 2008 18:27:09 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> On Mon, 28 Jul 2008 02:37:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
>=20
> > On powerpc (allyesconfig build) we get this error:
> >=20
> > drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit declaration =
of function 'virt_to_bus'
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> Can we please not merge new virt_to_bus users and instead fix the actual
> code to use the right functions?

Absolutely.  But I currently just want my trees to build (I am a bear of
little brain with simple needs :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Jul_2008_10_15_33_+1000_GNfKP+ALpr7twsJe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiND6UACgkQjjKRsyhoI8yh8gCdFxS/DySxGjWUC7Poy80amb4C
g+0An2LFyxLwKXjyJ4X068RjUKL42yb4
=CF5w
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jul_2008_10_15_33_+1000_GNfKP+ALpr7twsJe--
