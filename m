Return-Path: <linux-kernel-owner+w=401wt.eu-S936667AbXFGU3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936667AbXFGU3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXFGU27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:28:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54129 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934770AbXFGU26 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:28:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
In-Reply-To: Your message of "Thu, 07 Jun 2007 15:44:56 +0900."
             <4667A968.9080407@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070606020737.4663d686.akpm@linux-foundation.org> <7929.1181146132@turing-police.cc.vt.edu>
            <4667A968.9080407@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181248131_4816P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Jun 2007 16:28:51 -0400
Message-ID: <23214.1181248131@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181248131_4816P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Jun 2007 15:44:56 +0900, Tejun Heo said:
> Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 06 Jun 2007 02:07:37 PDT, Andrew Morton said:
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2
.6.22-rc4-mm1/
> > 
> > This one died a horrid death at boot time - console log indicates it found 
the
> > hard drive OK, found the 2 partitions on it.  But when the initrd ran a
> > 'lvm vgscan', it didn't find the LVM2 space on /dev/sda2, so it panic'ed wh
en
> > it fell off the end of the initrd because the root= wasn't there.
> > 
> > My first guess for blame:
> > 
> > gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
> > 
> > as that's awfully similar to gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
> > that broke 'lvm vgscan' for me in the same way on 21-rc7-mm[12].
> > 
> > I'll hopefully get a chance to revert that one and test later today - a quick
> > 'patch -p1 -R --dry-run' shows a number of conflicts that will need hand-fixing
> > at the very least.
> 
> Did rc3-mm1 work?  Can you find out the first broken -mm?

21-rc5-mm2 worked, -rc6-mm* were busticated for other reasons on my laptop,
21-rc7-mm[12] were broken, 21-mm1 through 21-rc3-mm1 worked, -rc4-mm1 broke,
and -rc4-mm2 works. I could bisect through -rc4-mm1 if it's deemed useful,
Andrew just pushed -mm2 before I had a chance.

--==_Exmh_1181248131_4816P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGaGqDcC3lWbTT17ARAqmNAKDjrvIpzvxRO6AeNW/68a2U4tdplgCfYvpR
jsecD3CInnR1IGJfle89AXw=
=Ol+e
-----END PGP SIGNATURE-----

--==_Exmh_1181248131_4816P--
