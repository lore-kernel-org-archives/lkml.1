Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZADNyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZADNyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZADNxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:53:54 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36401 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZADNxx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:53:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
In-Reply-To: Your message of "Sun, 04 Jan 2009 18:35:41 +0500."
             <4960BB2D.3060000@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20090103123813.GA1512@ucw.cz>
            <4960BB2D.3060000@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231077195_3941P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Jan 2009 08:53:15 -0500
Message-ID: <129621.1231077195@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231077195_3941P
Content-Type: text/plain; charset=us-ascii

On Sun, 04 Jan 2009 18:35:41 +0500, "Alexander E. Patrakov" said:

> Ext3 means either hardware that supports barriers (not sure how to 
> check, and anyway I have to use encryption on the work laptop due to the 
> corporate policy) or disabling write cache (but, as Alan Cox said, this 
> shortens the lifespan of the disk).

False dichotomy.  This isn't an "either/or", as there's a *third* case:

"understand the issues and risks involved if you have a write cache and
no barrier support, and learn to deal with it".

As you point out, if it's a laptop with a battery, the risk may be *very* low.
Let's say there's a 1 in 10,000 chance that you'll trash a file system and
need to restore from backups.

That may be totally acceptable if you've already estimated a 1 in 500 chance
of the whole damned laptop going walkies while you're not looking, and then
you *still* need to be able to restore from backups onto a replacement machine.

Yes, for some systems, the whole barriers/write cache thing is in fact very
important.  But for others, data loss due to spilled coffee is a bigger worry...

--==_Exmh_1231077195_3941P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYL9LcC3lWbTT17ARAnLhAJ9Pl7zOpCpuUaOeCQMBXTL/hDwmSwCgkxwZ
3HOLjlf3o03v15MEzoNLprY=
=GNzZ
-----END PGP SIGNATURE-----

--==_Exmh_1231077195_3941P--
