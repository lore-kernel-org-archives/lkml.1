Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXJDMrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXJDMrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXJDMrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:47:05 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:59650 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbXJDMrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:47:04 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 08:47:03 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "yogeshwar sonawane" <yogyas@gmail.com>
Subject: Re: Accessing 64-bit BARs
Date: Thu, 4 Oct 2007 14:40:10 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <b681c62b0710040153w5b4779fat1ccc7fa3e5775c2c@mail.gmail.com>
In-Reply-To: <b681c62b0710040153w5b4779fat1ccc7fa3e5775c2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1355874.Eb3FABm1au";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710041440.15464.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1355874.Eb3FABm1au
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag, 4. Oktober 2007 schrieb yogeshwar sonawane:
> Hello all,
>
> For accessing memory-mapped 64bit-BAR regions of a PCI card, the
> respective BAR regions has to be made accessible to the kernel using
> ioremap() function. Then readl()/writel() can be used on the address
> returned by ioremap().

You should use pci_iomap() to get an access pointer to the BAR. After this =
you=20
can access the memory with ioread*() and iowrite*(). See "man pci_iomap(9)"=
=20
if you build kernel manpages.

Greetings,

Eike

--nextPart1355874.Eb3FABm1au
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHBN8vXKSJPmm5/E4RAjNGAJ0TLDCCKcShehRJGF0jWq8wDr0LBACdEoo6
S2NVyCYQ6BlzXxvlB0HVsAk=
=2c9Z
-----END PGP SIGNATURE-----

--nextPart1355874.Eb3FABm1au--
