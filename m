Return-Path: <linux-kernel-owner+w=401wt.eu-S973502AbXHMRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973502AbXHMRCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972954AbXHMQhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:37:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42421 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S972169AbXHMQhd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:37:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [2/2many] - FInd the maintainer(s) for a patch - MAINTAINERS
In-Reply-To: Your message of "Sun, 12 Aug 2007 23:10:16 PDT."
             <1186985416.10249.13.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <1186985416.10249.13.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187022990_3175P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 12:36:30 -0400
Message-ID: <9866.1187022990@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187022990_3175P
Content-Type: text/plain; charset=us-ascii

On Sun, 12 Aug 2007 23:10:16 PDT, Joe Perches said:

> +   A trailing slash includes all files and subdirectory files.
> +	F:	drivers/net/	all files in and below drivers/net
> +	F:	drivers/net/*	all files in drivers/net, but not below

Since somebody is going to screw up and do it - what are the semantics of
'drivers/net' and forgetting the trailing slash?  Does your tool break on
that, and if so, is it silent or noisy (if it's silent, it won't get fixed).

> +	F:	*/net/*		all files in "any top level directory"/net

Does the leading '*' match exactly one level, or will it match foo/bar/net/*
as well?

Is a construction like 'net/*/netfilter/*' legal?


--==_Exmh_1187022990_3175P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGwIiOcC3lWbTT17ARAh+wAKDXlV4sIhc28znoCtO/AnAMah35GgCgsX25
Mjp/OI4W3UoAPfd/anZQjjA=
=gobL
-----END PGP SIGNATURE-----

--==_Exmh_1187022990_3175P--
