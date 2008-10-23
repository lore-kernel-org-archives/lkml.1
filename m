Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYJWIjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYJWIjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYJWIjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:39:14 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:57796 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYJWIjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:39:13 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Date: Thu, 23 Oct 2008 10:38:44 +0200
User-Agent: KMail/1.9.10
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081023032833.GK26094@parisc-linux.org> <20081023064412.GD31186@colo.lackof.org>
In-Reply-To: <20081023064412.GD31186@colo.lackof.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1379877.ZpokHbv6kG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810231038.52151.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1379877.ZpokHbv6kG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Grant Grundler wrote:

> Lastly, /sys seems to have over run even /proc. On an rx2600 (ia64):
> grundler@gsyprf3:/usr/src/linux-2.6$ find /sys ! -type d | wc
>    6288    6296  264893

/sys is full of symlinks which /proc is not.

--nextPart1379877.ZpokHbv6kG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkAOBwACgkQXKSJPmm5/E491ACfQHCL6A/X5bT9QVrdCFfrNe+X
x28An0aeL+VNEgmPqgETIJUkIsZ0/ydP
=WuYi
-----END PGP SIGNATURE-----

--nextPart1379877.ZpokHbv6kG--
