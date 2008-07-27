Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYG0DoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYG0DoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYG0Dn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:43:56 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60716 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbYG0Dn4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:43:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.26-mmotm-0724 - linux-next.git loses /proc/sys/fs/quota, breaks disk quotas
In-Reply-To: Your message of "Sat, 26 Jul 2008 20:25:25 PDT."
             <20080726202525.3ac3052f.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <14615.1217125366@turing-police.cc.vt.edu>
            <20080726202525.3ac3052f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1217130229_3032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 23:43:49 -0400
Message-ID: <21657.1217130229@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1217130229_3032P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 Jul 2008 20:25:25 PDT, Andrew Morton said:

> You need to grab the git tree and use git-bisect.  Then wade through
> all the runtime and compile-time bisection breakage which people
> nowadays seem to find acceptable because git collapses in an
> ignominious heap when these are fixed.

I've bisected through Linus' tree more than once - ISTR that there was
some special funkiness in dealing with trying to bisect through linux-next
because the tree gets redone every night.

If it *was* as easy as Linus's tree to bisect, I'd go ahead and do it.

> > Anybody know where /proc/sys/fs/quota went?

> Nope.  There are pretty extensive changes to procfs core in the vfs
> tree - perhaps something there made /proc/sys/fs/quota vanish.
> 
> <checks>
> 
> Yup, it happens in the most recent linux-next too.
> 
> Ah, it seems to be taking a little vacation over in
> /proc/sys/kernel/.  Curious.

Wow. I never *thought* to look for it there, and neither did my userspace :)




--==_Exmh_1217130229_3032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIi+71cC3lWbTT17ARArqEAJ4ssQUhJT53wngX+Wq/sEHga1Hd9ACdEw7Z
r3b7X4lwDhYwupQlT2DLvgk=
=k5Wd
-----END PGP SIGNATURE-----

--==_Exmh_1217130229_3032P--
