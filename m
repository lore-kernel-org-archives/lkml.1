Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbXL1RYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbXL1RYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 12:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXL1RX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 12:23:59 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59228 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXL1RX6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 12:23:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
In-Reply-To: Your message of "Fri, 28 Dec 2007 23:32:09 +0900."
             <200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <200712252133.JFF05267.FOMFtOLJHSOVFQ@I-love.SAKURA.ne.jp> <20071226164230.GA14210@sergelap.austin.ibm.com> <200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp> <20071227145431.GB5161@sergelap.austin.ibm.com>
            <200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198862631_2814P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 12:23:51 -0500
Message-ID: <27904.1198862631@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198862631_2814P
Content-Type: text/plain; charset=us-ascii

On Fri, 28 Dec 2007 23:32:09 +0900, Tetsuo Handa said:

> You can run your system with only policy collected by learning mode.
> Thus, you basically don't need manual intervention.
> But since there are randomly named files (i.e. temporary files),
> you pay a little time to modify policy.
> 
> The learning mode is to save time for permitting commonly accessed resources.
> Administrator reviews policy collected by learning mode. Thus the readability
> of policy is important so that administrator can understand what he/she is
> going to allow or reject.

Please make a *big* notation someplace that "learning mode" is quite likely to
*not* produce a totally correct policy.  In particular, it won't build rules for
infrequently used code paths (such as error handling) unless you find a way to
exercise those paths while in learning mode.

Particularly fun - when learning mode doesn't create an entry for the logfile
for I/O errors.  Then when one actually happens, you have no idea what it was...

--==_Exmh_1198862631_2814P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdTEncC3lWbTT17ARAkHdAKDa9YMx7omJmf3X65VtDwHCZN9RRwCfVcN+
+oUDp62n2NG5a265pDaG5EI=
=P215
-----END PGP SIGNATURE-----

--==_Exmh_1198862631_2814P--
