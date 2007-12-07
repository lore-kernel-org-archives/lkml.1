Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbXLGUjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbXLGUjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXLGUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:39:29 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48390 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXLGUj3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:39:29 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [NFS] NFSv2/3 broken exporting/mounting (permission denied) in 2.6.24-rc4
In-Reply-To: Your message of "Fri, 07 Dec 2007 15:06:55 EST."
             <20071207200655.GD2204@fieldses.org>
From: Valdis.Kletnieks@vt.edu
References: <20071207025504.GA3070@fieldses.org> <200712072000.lB7K0DZ5013256@agora.fsl.cs.sunysb.edu>
            <20071207200655.GD2204@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1197059924_2992P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Dec 2007 15:38:44 -0500
Message-ID: <4734.1197059924@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1197059924_2992P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4728.1197059924.1@turing-police.cc.vt.edu>

On Fri, 07 Dec 2007 15:06:55 EST, "J. Bruce Fields" said:
> On Fri, Dec 07, 2007 at 03:00:13PM -0500, Erez Zadok wrote:

> > commit 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
> > Author: Eric W. Biederman <ebiederm@xmission.com>
> > Date:   Sun Dec 2 00:33:17 2007 +1100

> Those files are actually in a separate filesystem (of type "nfsd") which
> is supposed to be mounted on /proc/fs/nfsd/.   So that mount must have
> failed in the bad case?  It's not immediately obvious to me what this
> patch has to do with that.  Hm.

For what it's worth, the startup scripts for 'wine' and 'jexec' fail as well,
and at shutdown, I get complaints about being unable to dismount 
/proc/sys/fs/binfmt_misc. 'strace' says:

open("/proc/sys/fs/binfmt_misc/windows", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 EN
OENT (No such file or directory)

# grep binfmt /proc/mounts
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0

I have to wonder if the fact there's 2 of them mounted is related to the
fact that 2 startup scripts tried to touch files under fs/binfmt_misc/ ?


--==_Exmh_1197059924_2992P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHWa9UcC3lWbTT17ARAjjLAJ0ZJ9G1fu8JZl8pBUtGi20lb1YGnQCeNVV6
zrGR7CdbouAlqBPVylThcRs=
=b2cP
-----END PGP SIGNATURE-----

--==_Exmh_1197059924_2992P--
