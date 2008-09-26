Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbYIZCTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbYIZCTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYIZCTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:19:12 -0400
Received: from mail.anarazel.de ([217.115.131.40]:50435 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYIZCTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:19:11 -0400
From: Andres Freund <andres@anarazel.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Date: Fri, 26 Sep 2008 04:18:50 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-rc7; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200809251511.20132.andres@anarazel.de> <48DC44D4.8000103@garzik.org>
In-Reply-To: <48DC44D4.8000103@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2391497.0mNc8PqLAe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809260419.07713.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2391497.0mNc8PqLAe
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jeff,

On Friday 26 September 2008, you wrote in "Re: bad DMAR interaction with=20
iwlagn and SATA":
> Andres Freund wrote:
> > sleeping I activated DMAR...
> > ..
> > Second:
> > [ 2937.484251] DMAR:[DMA Read] Request device [00:1f.2] fault addr
> > fffbf000 [ 2937.484255] DMAR:[fault reason 06] PTE Read access is not s=
et
> > [ 2937.484297] ata1.00: exception Emask 0x60 SAct 0x1 SErr 0x800 action
> > 0x6 frozen
> > [ 2937.484303] ata1.00: irq_stat 0x20000000, host bus error
> > [ 2937.484309] ata1: SError: { HostInt }
> > [ 2937.484319] ata1.00: cmd 61/08:00:c0:1d:6b/00:00:07:00:00/40 tag 0 n=
cq
> > 4096 out
> > [ 2937.484321]          res 40/00:00:c0:1d:6b/00:00:07:00:00/40 Emask
> > 0x60 (host bus error)
> Ouch, a host bus error is serious nastiness...
I only hit that with DMAR activated (hit it twice, different boots), so it=
=20
seems to be related to that. Is there anything I can help to debug that?

Andres

--nextPart2391497.0mNc8PqLAe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjcRosACgkQporPraT14igTKwCfXFLNDkOftx7ddVEKoKIOnhpe
WUMAnj6SpTxIjHRZSHGzzKsUB9KjE+S+
=pX3H
-----END PGP SIGNATURE-----

--nextPart2391497.0mNc8PqLAe--
