Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYBOQrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYBOQrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYBOQrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:47:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42766 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbYBOQrF (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:47:05 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       jack@suse.cz
Subject: isofs - Re: 2.6.24-mm1 bugs
In-Reply-To: Your message of "Fri, 15 Feb 2008 12:43:45 +0100."
             <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
From: Valdis.Kletnieks@vt.edu
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203094015_2934P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 11:46:55 -0500
Message-ID: <19039.1203094015@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203094015_2934P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Feb 2008 12:43:45 +0100, Miklos Szeredi said:
> I'm trying out 2.6.24-mm1 on my work laptop (T60), and generally it

>  - mounting isofs always results in an empty directory

I hit this in 24-rc8-mm1, and bisected it down to
iget-stop-isofs-from-using-read_inode-fix-2.patch

Apparently it got broken way back in 24-rc6-mm1.

And that directory is *really* empty - even . and .. are missing. :)

--==_Exmh_1203094015_2934P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHtcH/cC3lWbTT17ARAi2SAJ9AfLwuSlLxH3BLwGLldUSVeSnr3QCeKAg1
wJmB+LXB89s4T8oCATDaCE4=
=OuVZ
-----END PGP SIGNATURE-----

--==_Exmh_1203094015_2934P--
