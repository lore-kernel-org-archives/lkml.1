Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYBTDm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYBTDm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYBTDms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:42:48 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41626 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYBTDmr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:42:47 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Andrew <nick@nick-andrew.net>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 4/9]
In-Reply-To: Your message of "Wed, 20 Feb 2008 01:38:55 +1100."
             <20080219143855.GB27352@tull.net>
From: Valdis.Kletnieks@vt.edu
References: <20080219140609.GA26619@tull.net>
            <20080219143855.GB27352@tull.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203478930_762P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Feb 2008 22:42:10 -0500
Message-ID: <4760.1203478930@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203478930_762P
Content-Type: text/plain; charset=us-ascii

On Wed, 20 Feb 2008 01:38:55 +1100, Nick Andrew said:

> +	  Enable an auditing infrastructure that can be used with another
> +	  kernel subsystem, such as Security-Enhanced Linux (SELinux),
> +	  which requires this option for logging of AVC messages output.
> +
> +	  AVC refers to Access Vector Cache, a subsystem used by SELinux
> +	  to improve performance of the security checking by caching
> +	  previous access decisions.

This paragraph can be dropped, as the reasons that SELinux denial messages
are tagged with 'avc' are mostly historical.   If you want to expand on anything
in here, explain that 'AVC' messages are interesting because they indicate
some sort of security rule denial.  So - if you don't enable auditing,
your security messages end up in the kernel syslog.  If you enable auditing,
they end up in the audit logs.  Explaining *that* clearly would be a lot
more useful than explaining what avc originally stood for.. ;)

--==_Exmh_1203478930_762P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHu6GScC3lWbTT17ARAhnsAKDkTzhS3qkTxI/PWVb1t+ANR75B8wCg/j5Y
QGki88VzjHwatY6fEIRgClo=
=kDUY
-----END PGP SIGNATURE-----

--==_Exmh_1203478930_762P--
