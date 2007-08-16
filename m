Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbXHPPbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbXHPPbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbXHPPax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:30:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41881 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbXHPPax (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:30:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: Your message of "Thu, 16 Aug 2007 11:09:16 EDT."
             <46C4689C.8020702@cfl.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com>
            <46C4689C.8020702@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187278162_618P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Aug 2007 11:29:22 -0400
Message-ID: <17471.1187278162@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187278162_618P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Aug 2007 11:09:16 EDT, Phillip Susi said:

> No recursion is needed because only one acl exists, so that is the only 
> one you need to update.  At least on disk.  Any cached acls in memory of 
> descendant objects would need updated, but the number of those should be 
> relatively small. 

On my laptop (this is a *laptop*, mind you):

% df -i /home
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/VolGroup00-home
                      655360  532361  122999   82% /home

What happens if I do a 'mv /home /home1'?  Looks like more than a "relatively
small" number.  A cold-cache 'find' takes a few minutes to wade through it all,
so any solutions you come up with should beware of locking issues...



--==_Exmh_1187278162_618P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxG1ScC3lWbTT17ARApU7AJ91L2jl43Lg13kefLbTlvYB+0fBTwCfVq4x
ipCVErpDU7d6HmhUrh0GDwQ=
=ci+c
-----END PGP SIGNATURE-----

--==_Exmh_1187278162_618P--
