Return-Path: <linux-kernel-owner+w=401wt.eu-S966108AbXDGQ5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966108AbXDGQ5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966109AbXDGQ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:57:10 -0400
Received: from h80ad275a.async.vt.edu ([128.173.39.90]:48108 "EHLO
	h80ad275a.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966108AbXDGQ5J (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:57:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: johnrobertbanks@fastmail.fm
Cc: Ignatich <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
In-Reply-To: Your message of "Sat, 07 Apr 2007 00:45:32 PDT."
             <1175931932.27274.1183445262@webmail.messagingengine.com>
From: Valdis.Kletnieks@vt.edu
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <1175909205.905.1183425104@webmail.messagingengine.com>
            <1175931932.27274.1183445262@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175965022_4736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 12:57:02 -0400
Message-ID: <13183.1175965022@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175965022_4736P
Content-Type: text/plain; charset=us-ascii

On Sat, 07 Apr 2007 00:45:32 PDT, johnrobertbanks@fastmail.fm said:

> Use rpm-pkg to create a Red Hat RPM kernel package.
> # make rpm-pkg
> 
> When built, the RPM package is put in
> /usr/src/packages/RPMS/*your*architecture*
> 
> # cd /usr/src/packages/RPMS/x86_64
> 
> Install the package (you may have to un-install previous installs)
> # rpm -i kernel-2.6.20-1.x86_64.rpm

It is *highly* recommended that you change the kernel identifier at
least slightly, so that you can install '2.6.20-1.local' without overlaying
the vendor-supplied 2.6.20-1 kernel.  Among other things, this lets you
boot back to the equivalent code level in the vendor kernel, so you can figure
out if it's your .config file that's broken, or if you hit a bug upggrading
from 2.6.19-10 to 2.6.20-1.

--==_Exmh_1175965022_4736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGF81ecC3lWbTT17ARAq6zAKDlzFh1SIH00/TlrtFOHyUma0DmjQCfW6Xl
HZbqcmdLjRKrH0RrxIeAgYI=
=5UYo
-----END PGP SIGNATURE-----

--==_Exmh_1175965022_4736P--
