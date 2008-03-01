Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbYCAC5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbYCAC5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 21:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbYCAC5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 21:57:37 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42535 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYCAC5g (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 21:57:36 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ptb@inv.it.uc3m.es
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: sysctl in 2.6.24.2 excludes unapproved files from /proc/sys?
In-Reply-To: Your message of "Sat, 01 Mar 2008 02:12:05 +0100."
             <200803010112.m211C5h4027092@betty.it.uc3m.es>
From: Valdis.Kletnieks@vt.edu
References: <200803010112.m211C5h4027092@betty.it.uc3m.es>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204340252_3290P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Feb 2008 21:57:32 -0500
Message-ID: <31088.1204340252@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204340252_3290P
Content-Type: text/plain; charset=us-ascii

On Sat, 01 Mar 2008 02:12:05 +0100, "Peter T. Breuer" said:
> A change in 2.6.24.x kernel/sysctl.c seems to exclude exo-kernel drivers
> from using the /proc/sys/ interface:

> 
> What's a person to do? 

Umm.. as a wild guess? Maybe a patch to add entries to the sysctl_check_table
arrays for your sysctl?

They didn't spend their holiday just coming up with this to annoy you - the
checking found a *lot* of entries that were well and truly broken (in the
how-did-it-ever-not-panic sense)...

Yes, it does make it more difficult for out-of-tree modules to create a new
sysctl entry - which is probably just as well, given that there's sysfs and
debugfs and a whole lot of other options as well for userspace-kernel
interaction.


--==_Exmh_1204340252_3290P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHyMYccC3lWbTT17ARAnCTAKDJ8ojMtxVVI6FmPViyK8lKsyvWXgCg6O5H
wzX83I8mzRj/iP5InMoGwgI=
=+5Qu
-----END PGP SIGNATURE-----

--==_Exmh_1204340252_3290P--
