Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYG0Fxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYG0Fxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 01:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYG0Fxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 01:53:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56628 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYG0Fxh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 01:53:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Re: 2.6.26-mmotm-0724 - linux-next.git loses /proc/sys/fs/quota, breaks disk quotas
In-Reply-To: Your message of "Sun, 27 Jul 2008 06:17:02 BST."
             <20080727051702.GY28946@ZenIV.linux.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu> <20080727040908.GX28946@ZenIV.linux.org.uk>
            <20080727051702.GY28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1217138011_3032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 27 Jul 2008 01:53:31 -0400
Message-ID: <29790.1217138011@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1217138011_3032P
Content-Type: text/plain; charset=us-ascii

On Sun, 27 Jul 2008 06:17:02 BST, Al Viro said:
> Wait... I remember fixing exactly that, but the fix is not in there...
> Bugger.  Botched "fold on reorder", fortunately still findable in old local
> branch.

I guess we're fortunate that you remembered and found the fix - else this
would quickly have degenerated into a "How did it *ever* work?"..

> Sigh... Why does that stuff show up after 10 days in linux-next, about
> 5 minutes after seeing it merged into mainline?  Murphy's fun...

I have to conclude that I'm the first person who actually tried the quota
support against either a linux-next or -mmotm kernel in the last 2 weeks,
which says something about our testing coverage.

Looking at the patch, I have to wonder what *else* was broken and nobody
noticed...

--==_Exmh_1217138011_3032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIjA1bcC3lWbTT17ARAgmzAKCsIVfxlOhRnmlCiwwJFikiUlts5QCeOHpl
doCjC7y4s0i/kgBSiI4dUu0=
=Mngc
-----END PGP SIGNATURE-----

--==_Exmh_1217138011_3032P--
