Return-Path: <linux-kernel-owner+w=401wt.eu-S933025Ab0AGDsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab0AGDsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932362Ab0AGDsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:48:30 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55736 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0AGDs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:48:29 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded
In-Reply-To: Your message of "Wed, 06 Jan 2010 14:34:36 PST."
             <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262836096_3937P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Jan 2010 22:48:16 -0500
Message-ID: <12343.1262836096@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (79) FH_DATE_PAST_20XX,HELO_LOCALHOST
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4B455980.0160,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262836096_3937P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jan 2010 14:34:36 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Building with CONFIG_SQUASHFS=m, CONFIG_SQUASHFS_LZMA=y ,
and CONFIG_DECOMPRESS_LZMA=n fails:

Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 219 modules
ERROR: "unlzma" [fs/squashfs/squashfs.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Looks like a missing select/depends for DECOMPRESS_LZMA.  Somebody else can
decide which it should be...




--==_Exmh_1262836096_3937P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLRVmAcC3lWbTT17ARAhNEAKDx67XObt4WlzZAuPmgSuxeGW8NlwCfRQ1b
cFds2M/La/91xChRaLcRfqY=
=i12v
-----END PGP SIGNATURE-----

--==_Exmh_1262836096_3937P--

