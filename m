Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbXFBBG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbXFBBG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbXFBBGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:06:20 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:60212 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbXFBBGT (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:06:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777 warning
In-Reply-To: Your message of "Fri, 01 Jun 2007 16:00:30 PDT."
             <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com> <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com> <20070601135900.ec44b1aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com> <20070601151649.bb23c6f9.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com> <20070601153328.1118ccaf.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
            <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180746300_4213P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Jun 2007 21:05:00 -0400
Message-ID: <6985.1180746300@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180746300_4213P
Content-Type: text/plain; charset=us-ascii

On Fri, 01 Jun 2007 16:00:30 PDT, Linus Torvalds said:

> 	#define BADPTR ((void *)16)

> I bet you'd find *more* problems that way than by returning NULL, and 
> you'd also avoid the whole problem with "if (!ptr) return -ENOMEM".

Hmm.. this looks like a good contender for "first usage of #ifndef CONFIG_STABLE"

:)

--==_Exmh_1180746300_4213P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYMI8cC3lWbTT17ARAqruAKDbUbEj1tUbC7ZoHF9Fw3DHQBkyDACfcH0r
1W2QHyZoA+qVv2pgYd2DMf8=
=1Ctr
-----END PGP SIGNATURE-----

--==_Exmh_1180746300_4213P--
