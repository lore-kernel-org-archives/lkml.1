Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYI2RDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYI2RDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYI2RCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:02:54 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:40751 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYI2RCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:02:53 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
Date: Mon, 29 Sep 2008 19:02:37 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20080928163611.3df8a9e0@infradead.org>
In-Reply-To: <20080928163611.3df8a9e0@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1808441.iSY7s540mx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809291902.44813.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1808441.iSY7s540mx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Arjan van de Ven wrote:
> The patch below introduces a pci_ioremap() function that should make it
> easier for driver authors to do the right thing for the simple, common
> case.
>
> There's also 18 patches that introduce users of this; to reduce lkml noise
> I've only stuck them in a git tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-pci_ioremap.g
>it
> (http://git.kernel.org/?p=linux/kernel/git/arjan/linux-2.6-pci_ioremap.git;
>a=summary)
>
>
> From fef1dd836bc7dc07962a0ae4019af9efd373c76f Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 26 Sep 2008 16:34:52 -0700
> Subject: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
>
> A common thing in many PCI drivers is to ioremap() an entire bar.
> This is a slightly fragile thing right now, needing both an address and a
> size, and many driver writers do.. various things there.
>
> This patch introduces an pci_ioremap() function taking just a PCI device
> struct and the bar number as arguments, and figures this all out itself, in
> one place. In addition, we can add various sanity checks to this function
> (the patch already checks to make sure that the bar in question really is a
> MEM bar; few to no drivers do that sort of thing).

This is the same like pci_iomap(pdev, number, 0), no?

Greetings,

Eike

--nextPart1808441.iSY7s540mx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjhCjQACgkQXKSJPmm5/E7P/wCeIeEicfs1lcyEMgvBs5sYodyU
lFcAoIggPnl02ujOMhrqeVXgGdrc/kcp
=sLlo
-----END PGP SIGNATURE-----

--nextPart1808441.iSY7s540mx--
