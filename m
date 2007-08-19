Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXHSVM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXHSVM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 17:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXHSVMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 17:12:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39584 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXHSVMt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 17:12:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: casey@schaufler-ca.com, Pavel Machek <pavel@ucw.cz>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
In-Reply-To: Your message of "Sat, 18 Aug 2007 01:29:58 EDT."
             <CB1BB3E1-68AB-4F7E-B8F8-466C4E471856@mac.com>
From: Valdis.Kletnieks@vt.edu
References: <638227.18984.qm@web36610.mail.mud.yahoo.com>
            <CB1BB3E1-68AB-4F7E-B8F8-466C4E471856@mac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187557961_3025P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 19 Aug 2007 17:12:41 -0400
Message-ID: <19578.1187557961@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187557961_3025P
Content-Type: text/plain; charset=us-ascii

On Sat, 18 Aug 2007 01:29:58 EDT, Kyle Moffett said:

> XFCE.  If you can show me a security system other than SELinux which  
> is sufficiently flexible to secure those 2 million lines of code  
> along with the other 50 million lines of code found in various pieces  
> of software on my Debian box then I'll go put on my dunce hat and sit  
> in the corner.

/me hands Kyle a dunce cap. :)

Unfortunately, I have to agree that both AppArmor and Smack have at least
the potential of qualifying as "securing the 2M lines of code".

The part that Kyle forgot was what most evals these days call the "protection
profile" - What's the threat model, who are you defending against, and just
how good a job does it have to do?  I'll posit that for a computer that
is (a) not networked, (b) doesn't process sensitive information, and (c) has
reasonable physical security, a security policy of "return(permitted);" for
everything may be quite sufficient.

(Of course, I also have boxes where "the SELinux reference policy with all
the MCS extensions plus all the LSPP work" is someplace I'm trying to get to).

--==_Exmh_1187557961_3025P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGyLJJcC3lWbTT17ARAqFVAKDSenWSgqF+HINMFJxTsjidtokI+QCg0qZW
3iBCHKnoVsKAd1ooFPBtzVI=
=8y7+
-----END PGP SIGNATURE-----

--==_Exmh_1187557961_3025P--
