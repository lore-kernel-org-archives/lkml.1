Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbXJYIvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbXJYIvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXJYIvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:51:45 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:45230 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbXJYIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:51:44 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6.24-rc1] fix sg_phys to use dma_addr_t
Date: Thu, 25 Oct 2007 10:51:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Hugh Dickins <hugh@veritas.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com> <20071024192949.346687ed@laptopd505.fenrus.org>
In-Reply-To: <20071024192949.346687ed@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1367313.G41zDuGPub";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710251051.30429.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1367313.G41zDuGPub
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Donnerstag, 25. Oktober 2007 schrieb Arjan van de Ven:
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> > Whether this is a complete patch, suitable for all architectures,
> > I'm not sure: it builds, boots and runs correctly on the x86_32 box
> > in question, but you'll be a lot wiser than me about using dma_addr_t
> > for everyone.  (Seems a bit of a shame to include <asm/types.h> here,
> > when I think all arches already get to include it one way or another,
> > typically via asm/scatterlist.h; but I guess it's safest to repeat
> > it.)
>
> there is a problem with this... sg_phys doesn't return an actual *dma*
> address.... at least not an address you can give to the device.
> Using dma_addr_t is thus a bit misleading.....

Ok, then: how do I actually get such an address?

Eike

--nextPart1367313.G41zDuGPub
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHIFkSXKSJPmm5/E4RAqZBAJ9kFhZuiVgTrEmS+qLJZNPOMNaCeACgk2e9
gInr9ENqUxCa9dBm6Agb5sY=
=hxdD
-----END PGP SIGNATURE-----

--nextPart1367313.G41zDuGPub--
