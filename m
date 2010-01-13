Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620Ab0AMWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0AMWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599Ab0AMWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:16:25 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51255 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AMWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:16:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-01-13-12-17 - 'make oldconfig' dies
In-Reply-To: Your message of "Wed, 13 Jan 2010 12:17:36 PST."
             <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263420974_4424P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jan 2010 17:16:14 -0500
Message-ID: <22290.1263420974@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B4E462F.0075,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263420974_4424P
Content-Type: text/plain; charset=us-ascii

On Wed, 13 Jan 2010 12:17:36 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Yow.

% make oldconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
In file included from scripts/basic/docproc.c:44:
/usr/include/sys/wait.h:67: error: conflicting types for '__WAIT_STATUS'
/usr/include/stdlib.h:72: note: previous declaration of '__WAIT_STATUS' was here
In file included from /usr/include/sys/wait.h:80,
                 from scripts/basic/docproc.c:44:
/usr/include/bits/waitstatus.h:68: error: redefinition of 'union wait'
make[1]: *** [scripts/basic/docproc] Error 1
make: *** [scripts_basic] Error 2

Looks to be busticated Fedora header files though. Heads up to anybody else
foolish enough to build -mm kernels under Fedora Rawhide. ;)

https://bugzilla.redhat.com/show_bug.cgi?id=554643


--==_Exmh_1263420974_4424P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLTkYucC3lWbTT17ARApRWAJ9hRUyV5vH3DudJC5DEGlbVnEnSBwCfbXVw
K+q/1nO6DVmkzrs86Uq/Lcg=
=YslC
-----END PGP SIGNATURE-----

--==_Exmh_1263420974_4424P--

