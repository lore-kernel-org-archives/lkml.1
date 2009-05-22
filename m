Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZEVF3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZEVF3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZEVF3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 01:29:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZEVF3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 01:29:11 -0400
Date: Fri, 22 May 2009 15:29:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the security-testing tree with Linus'
 tree
Message-Id: <20090522152901.2d220889.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_May_2009_15_29_01_+1000_qVRCPVgmR/E4jeys"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_May_2009_15_29_01_+1000_qVRCPVgmR/E4jeys
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security-testing tree got a conflict in
fs/exec.c between commits a44ddbb6d8a8ffe4e34e417048dfdd8f3dd1de4f ("Make
open_exec() and sys_uselib() use may_open(), instead of duplicating its
parts") and 6e8341a11eb21826b7192d0bb88cb5b44900a9af ("Switch open_exec()
and sys_uselib() to do_open_filp()") from Linus' tree and commit
b9fc745db833bbf74b4988493b8cd902a84c9415 ("integrity: path_check update")
from the security-testing tree.

I used the version of these conflicts from Linus' tree as I assume that
the changes to may_open() from the latter patch are sufficient.  Please
check and let me know (or merge Linus' tree and do the resolution for
yourself :-)).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_May_2009_15_29_01_+1000_qVRCPVgmR/E4jeys
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoWOB0ACgkQjjKRsyhoI8z0cQCgv1g+E7V4oB/bGST1K6vpM+s6
EMgAoKebuaZjwjAobYEQA4BDOUt1H/tb
=nMyZ
-----END PGP SIGNATURE-----

--Signature=_Fri__22_May_2009_15_29_01_+1000_qVRCPVgmR/E4jeys--
