Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbZGPTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbZGPTqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbZGPTqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:46:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41707 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbZGPTql (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:46:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add "VmUsers: N" to /proc/$PID/status
In-Reply-To: Your message of "Wed, 15 Jul 2009 03:22:18 +0200."
             <200907150322.18123.vda.linux@googlemail.com>
From: Valdis.Kletnieks@vt.edu
References: <200907150322.18123.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247773600_4382P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 15:46:40 -0400
Message-ID: <48286.1247773600@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247773600_4382P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Jul 2009 03:22:18 +0200, Denys Vlasenko said:

> It can be nice to know how many such CLONE_VM'ed processes
> share VM with given /proc/PID. Then it would be possible to do
> more accurate accounting of memory usage. Say, by dividing
> all memory usage numbers of this process by this number.

Process A clones a process A1.  Process B clones a process B1. Now
all 4 of them have 'VmUsers: 2' on them, but there's no clean way to tell
whether A1 or B1 is the one sharing with A, or with B.

The patch is probably sufficient if all you want is some N to divide by, but
not if you care *which* processes are sharing how much.

--==_Exmh_1247773600_4382P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKX4OgcC3lWbTT17ARArsTAJ9RWH4ihOKtaOKR/GZzjNT07vXh7gCfRNb3
vLI567qRnSeZ01HNvka5oWY=
=Sbe3
-----END PGP SIGNATURE-----

--==_Exmh_1247773600_4382P--
