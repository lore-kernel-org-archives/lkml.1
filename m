Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYGCTc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYGCTc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYGCTcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:32:16 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48164 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYGCTcP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:32:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
In-Reply-To: Your message of "Thu, 03 Jul 2008 19:56:02 BST."
             <1215111362.10393.651.camel@pmac.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <486CC440.9030909@garzik.org> <Pine.LNX.4.64.0807031353030.11033@blonde.site> <486CCFED.7010308@garzik.org> <1215091999.10393.556.camel@pmac.infradead.org> <486CD654.4020605@garzik.org> <1215093175.10393.567.camel@pmac.infradead.org> <20080703173040.GB30506@mit.edu>
            <1215111362.10393.651.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215113467_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 15:31:07 -0400
Message-ID: <92840.1215113467@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215113467_4193P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jul 2008 19:56:02 BST, David Woodhouse said:

> They had to 'make oldconfig' and then actually _choose_ to say 'no' to
> an option which is fairly clearly documented, that they are the
> relatively unusual position of wanting to have said 'yes' to. You're
> getting into Aunt Tillie territory, when you complain about that.

Note that some of us chose 'no' because we *thought* that we already *had*
everything in /lib/firmware that we needed (in my case, the iwl3945 wireless
firmware and the Intel cpu microcode).  The first that I realized that
the tg3 *had* firmware was when I saw the failure message, because before
that, the binary blob was inside the kernel.  And then, it wasn't trivially
obvious how to get firmware loaded if the tg3 driver was builtin rather
than a module.

And based on some of the other people who apparently got bit by this same
exact behavior change on this same exact "builtin but no firmware in kernel"
config with this same exact driver, it's obvious that one of two things is true:

1) Several of the highest-up maintainers are Aunt Tillies.
or
2) This is sufficiently subtle and complicated that far more experienced
people than Aunt Tillie will Get It Very Wrong.

--==_Exmh_1215113467_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbSj7cC3lWbTT17ARAgRJAJ9f5OBi6ZMoDDh4l/SOO5rzlbw3dgCg1KRC
0rGxreac3Gnc8oKVstJmfoI=
=CaEO
-----END PGP SIGNATURE-----

--==_Exmh_1215113467_4193P--
