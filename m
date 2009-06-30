Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZF3PIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZF3PIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZF3PIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:08:23 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:57903 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZF3PIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:08:22 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 11:08:22 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit x86
Date: Tue, 30 Jun 2009 17:00:45 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-git; KDE/4.2.4; i686; ; )
Cc: Mikael Pettersson <mikpe@it.uu.se>, Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com>
In-Reply-To: <4A4A25B1.5010102@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1369392.XX9jn8ZPop";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906301700.55536.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1369392.XX9jn8ZPop
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> > Thanks, 2.6.31-rc1 vanilla (which didn't boot) plus this one does boot.
> > /proc/iomem now looks as follows:
>
> ... as it should.  So far so good, and this is a real problem.
>
> However, there is something that really bothers me: *why does this help
> on Mikael's system, which is PAE and therefore has a 64-bit
> resource_size_t*?  This whole patch should be a no-op!  There is still
> something that doesn't make sense.
>
> The use of "unsigned long" in ram_alignment() will overflow after 2^52
> bytes, but again, that's not the issue here, since the highest "start"
> value we have is (0x2 << 32).

I assume you meant "2^32" and (0x1 << 32)?

Eike

--nextPart1369392.XX9jn8ZPop
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkpKKKcACgkQXKSJPmm5/E64zwCfeHSoe2U5ZodjEA6xjOGRy7OQ
i/oAnj+rrzrnuMsjs5xK8iDw9onIo4hM
=52Vj
-----END PGP SIGNATURE-----

--nextPart1369392.XX9jn8ZPop--
