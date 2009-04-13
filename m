Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZDMVHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZDMVHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZDMVHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:07:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59060 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZDMVG6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:06:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mtk.manpages@gmail.com,
       Stephen Smalley <sds@epoch.ncsc.mil>, Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, stable@kernel.org,
       linux-api@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] add some long-missing capabilities to fs_mask
In-Reply-To: Your message of "Mon, 13 Apr 2009 09:56:14 CDT."
             <20090413145614.GA15342@us.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20090413145614.GA15342@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239656608_7306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Apr 2009 17:03:28 -0400
Message-ID: <13502.1239656608@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239656608_7306P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Apr 2009 09:56:14 CDT, "Serge E. Hallyn" said:
> When POSIX capabilities were introduced during the 2.1 Linux
> cycle, the fs mask, which represents the capabilities which having
> fsuid==0 is supposed to grant, did not include CAP_MKNOD and
> CAP_LINUX_IMMUTABLE.  However, before capabilities the privilege
> to call these did in fact depend upon fsuid==0.

Wow. How did this manage to stay un-noticed for this long?

--==_Exmh_1239656608_7306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ46igcC3lWbTT17ARApmsAJ9uMHtKObtUKhn0nQ7P/Sc4pEp95wCcCgOf
Yzh1kFYnnKnsev2Lw/btpDU=
=gxka
-----END PGP SIGNATURE-----

--==_Exmh_1239656608_7306P--
