Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXHPVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXHPVPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXHPVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:15:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43803 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbXHPVPN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:15:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, pwil3058@bigpond.net.au
Subject: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for 2.6.22
In-Reply-To: Your message of "Thu, 16 Aug 2007 22:42:42 +0200."
             <1930295607@web.de>
From: Valdis.Kletnieks@vt.edu
References: <1930295607@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187298845_6540P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Aug 2007 17:14:05 -0400
Message-ID: <19230.1187298845@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187298845_6540P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Aug 2007 22:42:42 +0200, devzero@web.de said:

> i trust you kernel developers know what you are doing, but if scares me
> a little bit, that some integral and living part like O(1) being ripped off 
> and being replaced by something new. 

There's something even scarier - O(1) being taken out and replaced by multiple
new things, none of which ever gets fully tested because if one misbehaves,
the user says "so what" and tries another one without bothering to file a bug
report...

Been there, done that - I found a timing hole in the pluggable I/O schedulers
that probably nobody had managed to hit because there were 3 or 4 choices
available, and they just set a default they liked.  Turned out there was a
race condition if I/O happened while schedulers were being swapped.

--==_Exmh_1187298845_6540P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxL4dcC3lWbTT17ARAoISAKDwGmm12zyIWCZk1cvnCdNwcDI/XwCdE2yn
dTfqXHDkWdFIkFsX1yfb9gY=
=07kx
-----END PGP SIGNATURE-----

--==_Exmh_1187298845_6540P--
