Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748Ab0AGECO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0AGECO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638Ab0AGECL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:02:11 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:58596 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0AGECC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:02:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded
In-Reply-To: Your message of "Wed, 06 Jan 2010 22:48:16 EST."
             <12343.1262836096@localhost>
From: Valdis.Kletnieks@vt.edu
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
            <12343.1262836096@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262836907_3937P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Jan 2010 23:01:47 -0500
Message-ID: <12823.1262836907@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (79) FH_DATE_PAST_20XX,HELO_LOCALHOST
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B455CAC.011A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262836907_3937P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jan 2010 22:48:16 EST, Valdis.Kletnieks@vt.edu said:

> Building with CONFIG_SQUASHFS=m, CONFIG_SQUASHFS_LZMA=y ,
> and CONFIG_DECOMPRESS_LZMA=n fails:

> Looks like a missing select/depends for DECOMPRESS_LZMA.  Somebody else can
> decide which it should be...

Digging further:
  
  x Symbol: DECOMPRESS_LZMA [=n]                                            x  
  x   Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=y] || SQUASHFS_LZMA [=y x  

How the heck did this happen?  Looks like a SELECT *is* there but it's
not firing??!?

--==_Exmh_1262836907_3937P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLRVyrcC3lWbTT17ARAoYbAKDXBy1J17UYEa9YyttjTuaTdk4r3ACgm9KI
U9pDDDxZcOsO6u3quaV0Ens=
=UR5r
-----END PGP SIGNATURE-----

--==_Exmh_1262836907_3937P--

