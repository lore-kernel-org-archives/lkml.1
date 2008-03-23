Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYCWFSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYCWFSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 01:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYCWFSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 01:18:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57406 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbYCWFSd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 01:18:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@osdl.org, Trond.Myklebust@netapp.com,
       chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: Performance degradation measurement [was Re: [PATCH 06/37] Security: Separate task security context from task_struct [ver #34]]
In-Reply-To: Your message of "Wed, 19 Mar 2008 17:12:08 -0000."
             <17688.1205946728@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20080229004405.4142.32147.stgit@warthog.procyon.org.uk> <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
            <17688.1205946728@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1206249437_3492P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 23 Mar 2008 01:17:17 -0400
Message-ID: <25920.1206249437@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1206249437_3492P
Content-Type: text/plain; charset=us-ascii

On Wed, 19 Mar 2008 17:12:08 -0000, David Howells said:

(Sorry - finally catching up)

>  (1) SELinux enabled, none of the security patches:
> 
> 	(gdb) p (1.119+1.110+1.104+1.106+1.095+1.112+1.094+1.091+1.112)/9
> 	$3 = 1.104777777777777

>  (4) LSM/SELinux disabled, none of the security patches:
> 
> 	(gdb) p (1.121+1.136+1.137+1.121+1.122+1.131+1.121+1.131+1.118)/9
> 	$7 = 1.1264444444444437

What's up with *that*?  The *fastest* run with it disabled is 1.118, and
the *slowest* with it enabled is 1.119.  At that point, I have to wonder
what we're really measuring here....

--==_Exmh_1206249437_3492P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH5efdcC3lWbTT17ARAg2qAJwKHeKqOVtSgql6bvnN+qdx6dg5ywCfQrPf
5uPBBxeg5QOLo8zbaUxDe+0=
=gNsw
-----END PGP SIGNATURE-----

--==_Exmh_1206249437_3492P--
