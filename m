Return-Path: <linux-kernel-owner+w=401wt.eu-S1030348AbXBORdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348AbXBORdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030349AbXBORdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:33:50 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39278 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030348AbXBORdt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:33:49 -0500
Message-Id: <200702151733.l1FHXatF025688@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 2.6.20-mm1
In-Reply-To: Your message of "Thu, 15 Feb 2007 05:14:08 PST."
             <20070215051408.a7fb7d81.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171560816_3639P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Feb 2007 12:33:36 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171560816_3639P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Feb 2007 05:14:08 PST, Andrew Morton said:
> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> 
> Will appear later at
> 
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/

git-backlight.patch contains this:

+config BACKLIGHT_PROGEAR
+       tristate "Frontpath ProGear Backlight Driver"
+       depends on BACKLIGHT_CLASS_DEVICE && PCI && X86
+       default y
+       help
+         If you have a Frontpath ProGear say Y to enable the
+         backlight driver.

Should that be a default N or M, given that relatively few people have that
device?

--==_Exmh_1171560816_3639P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1JlwcC3lWbTT17ARAvpFAJ0eNWkf4yalFkvieC8Oqk8wHqbFkACgk8hd
9GKUHsEjmVlerB5dho4jZF4=
=Crft
-----END PGP SIGNATURE-----

--==_Exmh_1171560816_3639P--
