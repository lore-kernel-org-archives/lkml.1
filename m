Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbXCUTUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbXCUTUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933805AbXCUTUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:20:22 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42109 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbXCUTUW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:20:22 -0400
Message-Id: <200703211920.l2LJKI1K019114@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: rol@as2917.net
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
In-Reply-To: Your message of "Wed, 21 Mar 2007 20:13:50 BST."
             <04ea01c76bed$11b0d050$4b00a8c0@donald>
From: Valdis.Kletnieks@vt.edu
References: <04ea01c76bed$11b0d050$4b00a8c0@donald>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1174504818_3868P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Mar 2007 15:20:18 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1174504818_3868P
Content-Type: text/plain; charset=us-ascii

On Wed, 21 Mar 2007 20:13:50 BST, Paul Rolland said:
>
> So, obviously, tar is right...
> man 2 stat says :
>        The st_dev field describes the device on which this file resides.
> 
> and df -a reports :
> [root@host-181 src]# df -a
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/hda1              7936256   3105556   4421048  42% /

> So, obviously, /dev is on /, but the stat(2) says no.
> Who is right, and where is the bug ?

Might want to 'cat /proc/mounts', and ponder the fact that a filesystem
can be mounted and not listed in /etc/mtab, and then see if your system
has 'udev' installed and enabled.

--==_Exmh_1174504818_3868P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGAYVycC3lWbTT17ARAgGNAKDXMh1T4WnFvo2Ymz4DJe4kIp0zFwCfSep/
oFEa0ZjFICyKhJLC+Y4d+u4=
=RhWd
-----END PGP SIGNATURE-----

--==_Exmh_1174504818_3868P--
