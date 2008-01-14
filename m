Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYANSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYANSu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYANSut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:50:49 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41167 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYANSus (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:50:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Paul Moore <paul.moore@hp.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - oddness with IPv4/v6 mapped sockets hanging...
In-Reply-To: Your message of "Mon, 14 Jan 2008 13:22:10 EST."
             <32065.1200334930@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <30887.1200209733@turing-police.cc.vt.edu> <7197.1200327338@turing-police.cc.vt.edu> <200801141136.41140.paul.moore@hp.com> <31130.1200333948@turing-police.cc.vt.edu>
            <32065.1200334930@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200336639_3045P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jan 2008 13:50:39 -0500
Message-ID: <1030.1200336639@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200336639_3045P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Jan 2008 13:22:10 EST, Valdis.Kletnieks@vt.edu said:
> Apparently the only new commit in there since the tree that was in
> 24-rc6-mm1 is 5d95575903fd3865b884952bd93c339d48725c33 adding some warning
> printk's.  Would it be more productive to test against the full tree, or
> leaving out the one commit I already reverted?

<voice=Emily Litella> Nevermind... </voice> :)

The new commit won't apply with the other one reverted - it patches
security/selinux/netnode.c which was created by the problematic commit...

--==_Exmh_1200336639_3045P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHi67/cC3lWbTT17ARAhcOAJ4lcOtjiX2KFpgRzThIv7R97jwI/wCfbkON
QSI5ZyV+t5auk/buHyMHLt4=
=z0oi
-----END PGP SIGNATURE-----

--==_Exmh_1200336639_3045P--
