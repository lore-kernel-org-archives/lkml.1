Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYJAKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYJAKeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYJAKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:34:04 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:47305 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYJAKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:34:03 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Date: Wed, 1 Oct 2008 12:33:38 +0200
User-Agent: KMail/1.9.10
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080926163641.288bf868@infradead.org> <20081001052450.GB7348@colo.lackof.org> <20080930153001.1107c0de@infradead.org>
In-Reply-To: <20080930153001.1107c0de@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4995006.xRWqVrUQ5O";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810011233.45495.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4995006.xRWqVrUQ5O
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Arjan van de Ven wrote:
> On Tue, 30 Sep 2008 23:24:50 -0600
>
> Grant Grundler <grundler@parisc-linux.org> wrote:
> > > And pci_iomap() takes more parameters than most driver writers want
> > > or need. Most of the time it's "I want the whole bar"; even if my
> > > patch wraps around that, making the API simpler is still worth it
> > > imo
> >
> > You are right about that.
> > Would calling the API "pci_iomap_bar()" to keep the naming consistent
> > help make it more acceptable?
>
> I'm fine with pci_iomap_bar()... it meets my goals
> Would be nice if I'd be allowed to make it only work on MEM bars not IO
> bars (so that drivers don't accidentally end up calling this on an IO
> bar and then using readl() etc)

IIRC pci_iomap() was documented to work on both at it does "the right thing=
"=20
automatically.

Eike

--nextPart4995006.xRWqVrUQ5O
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjjUgkACgkQXKSJPmm5/E65LgCgjUOF0lp/d27coursp1wUAwgX
exwAn3a7tYzZuKkT6H4kQ/XSrlOM8xqt
=muWL
-----END PGP SIGNATURE-----

--nextPart4995006.xRWqVrUQ5O--
