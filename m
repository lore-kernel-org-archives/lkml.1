Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYBRRf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYBRRf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYBRRfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:35:11 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45161 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYBRRfK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:35:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: tbench regression in 2.6.25-rc1
In-Reply-To: Your message of "Mon, 18 Feb 2008 16:12:38 +0800."
             <1203322358.3027.200.camel@ymzhang>
From: Valdis.Kletnieks@vt.edu
References: <47B52B95.3070607@cosmosbay.com> <1203057044.3027.134.camel@ymzhang> <47B59FFC.4030603@cosmosbay.com> <20080215.152200.145584182.davem@davemloft.net>
            <1203322358.3027.200.camel@ymzhang>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203356033_2991P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 12:33:53 -0500
Message-ID: <20040.1203356033@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203356033_2991P
Content-Type: text/plain; charset=us-ascii

On Mon, 18 Feb 2008 16:12:38 +0800, "Zhang, Yanmin" said:

> I also think __refcnt is the key. I did a new testing by adding 2 unsigned long
> pading before lastuse, so the 3 members are moved to next cache line. The performance is
> recovered.
> 
> How about below patch? Almost all performance is recovered with the new patch.
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

Could you add a comment someplace that says "refcnt wants to be on a different
cache line from input/output/ops or performance tanks badly", to warn some
future kernel hacker who starts adding new fields to the structure?

--==_Exmh_1203356033_2991P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHucGBcC3lWbTT17ARAuBuAJoC9jm6ztQBAPBUryQDldMiNtKl4wCdF3r+
PnOci+BHj3mVt3k/X5tU/3A=
=6j9Z
-----END PGP SIGNATURE-----

--==_Exmh_1203356033_2991P--
