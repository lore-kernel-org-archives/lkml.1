Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYG0Gbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYG0Gbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYG0Gbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:31:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53528 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYG0Gbk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:31:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] lost sysctl fix
In-Reply-To: Your message of "Sun, 27 Jul 2008 06:31:22 BST."
             <20080727053122.GZ28946@ZenIV.linux.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu> <20080727040908.GX28946@ZenIV.linux.org.uk> <20080727051702.GY28946@ZenIV.linux.org.uk>
            <20080727053122.GZ28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1217140293_3034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 27 Jul 2008 02:31:33 -0400
Message-ID: <3146.1217140293@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1217140293_3034P
Content-Type: text/plain; charset=us-ascii

On Sun, 27 Jul 2008 06:31:22 BST, Al Viro said:
> try_attach() should walk into the matching subdirectory, not the first one...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> [and yes, that's what that crap had been]
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 911d846..fe47133 100644

I just built 26-mmotm-0727 with this patch on top of it, and can confirm
that disk quotas are functioning again.  Thanks, Al.  Feel free to
stick a Tested-By: on there...

--==_Exmh_1217140293_3034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIjBZFcC3lWbTT17ARAlY8AJ9zWf4icQyhWoH2qgNz0m8pYGdy0wCgvj4N
8YS73DloHMQZ94C0htEeIys=
=szZ1
-----END PGP SIGNATURE-----

--==_Exmh_1217140293_3034P--
