Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXI3CTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXI3CTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 22:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXI3CTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 22:19:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56532 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXI3CTH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 22:19:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
In-Reply-To: Your message of "Sat, 29 Sep 2007 03:51:56 PDT."
             <20070929035156.cd6fe860.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070929122530.5c45f743@hyperion.delvare>
            <20070929035156.cd6fe860.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191118736_2993P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Sep 2007 22:18:56 -0400
Message-ID: <17982.1191118736@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191118736_2993P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Sep 2007 03:51:56 PDT, Andrew Morton said:

> Printing something like
> 
> 	bytes remaining: 0x12 (18)
> 
> is a quite logical thing to do, although pretty darm pointless.

On the other hand, printing this:

        magic number: 0x2710

probably doesn't ring any bells, but if you changed that format to be

	"magic number: %x (%d)",foo,foo

you'll almost certainly sit up and ask "Where the fsck did *that* come from?"

(unless you're a *lot* better at doing hex conversions in your head than I).

Yeah, *usually* pointless, but it has its place sometimes....


--==_Exmh_1191118736_2993P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG/weQcC3lWbTT17ARAmLsAKD3SdKRXcaj3aEpZ4w2I7wroCn+cgCdG/0M
DO95SFsFNdiGqmoj3banUms=
=nRDV
-----END PGP SIGNATURE-----

--==_Exmh_1191118736_2993P--
