Return-Path: <linux-kernel-owner+w=401wt.eu-S1422677AbXBAQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422677AbXBAQB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422686AbXBAQB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:01:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47835 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422677AbXBAQB0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:01:26 -0500
Message-Id: <200702011600.l11G08Zs015498@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: wsl3@lrsehosting.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alan@redhat.com, Adrian Bunk <bunk@stusta.de>
Subject: Re: Unidentified Intel wifi network card
In-Reply-To: Your message of "Thu, 01 Feb 2007 08:59:47 +1100."
             <20070131215947.GA28294@gondor.apana.org.au>
From: Valdis.Kletnieks@vt.edu
References: <1170264624.5569.15.camel@scott-640m> <200701312054.l0VKstxg020891@turing-police.cc.vt.edu>
            <20070131215947.GA28294@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170345608_13753P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Feb 2007 11:00:08 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170345608_13753P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Feb 2007 08:59:47 +1100, Herbert Xu said:
> On Wed, Jan 31, 2007 at 03:54:55PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > 
> > Oh - the git-crypto-fix patch has to be applied with -R, I never got around
 to
> > re-diffing it the other way.
> 
> If this driver is still using the old digest interface, it needs to be
> converted to use crypto_hash_*.

OK, here's the more complete scoop - the *out of tree* ieee80211 tree
hasn't been converted, but the *in tree* version has.

Why did I have the out of tree version installed? Because the in-tree
version claimed to be 1.1.3, and the out-of-tree 1.2.16.  Apparently,
the update to the version string for the in-kernel version got blocked
someplace - the in-tree is apparently actually very close to 1.2.16.

--==_Exmh_1170345608_13753P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFwg6IcC3lWbTT17ARAoJ1AKDw1SiIvR4bcQEIMnwloXIgX3nZOQCgzNik
x7tXAekTl0eYsXFV4Eao8Ko=
=rArN
-----END PGP SIGNATURE-----

--==_Exmh_1170345608_13753P--
