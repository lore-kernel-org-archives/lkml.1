Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZGPBgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZGPBgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZGPBgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:36:20 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:36707 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbZGPBgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:36:19 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@tiscali.co.uk>
In-Reply-To: <20090715074952.A36C7DDDB2@ozlabs.org>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3sW64rSI2yIG/UuMyqDm"
Date: Thu, 16 Jul 2009 11:36:17 +1000
Message-Id: <1247708177.9851.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3sW64rSI2yIG/UuMyqDm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 17:49 +1000, Benjamin Herrenschmidt wrote:
> Upcoming paches to support the new 64-bit "BookE" powerpc architecture
> will need to have the virtual address corresponding to PTE page when
> freeing it, due to the way the HW table walker works.

> I haven't had a chance to test or even build on most architectures, the
> patch is reasonably trivial but I may have screwed up regardless, I
> appologize in advance, let me know if something is wrong.

Builds for the important architectures, powerpc, ia64, arm, sparc,
sparc64, oh and x86:

http://kisskb.ellerman.id.au/kisskb/head/1976/

(based on your test branch 34f25476)

cheers

--=-3sW64rSI2yIG/UuMyqDm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpehAQACgkQdSjSd0sB4dIe4QCgsEWUeUUCjt33SGp2XpLqD/1W
/QsAn37UyeAeK5Msl22yj/kzj0VYowyT
=Lbt0
-----END PGP SIGNATURE-----

--=-3sW64rSI2yIG/UuMyqDm--

