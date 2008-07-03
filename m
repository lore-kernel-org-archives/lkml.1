Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYGCNzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYGCNzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbYGCNzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:55:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44920 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180AbYGCNzG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:55:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, arjan@infradead.org
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World Order firmware...
In-Reply-To: Your message of "Thu, 03 Jul 2008 15:03:32 +0200."
             <1215090212.9721.91.camel@linux.site>
From: Valdis.Kletnieks@vt.edu
References: <4534.1215048758@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet> <32146.1215066947@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet> <1215077028.10393.497.camel@pmac.infradead.org> <65663.1215080245@turing-police.cc.vt.edu> <1215081029.10393.517.camel@pmac.infradead.org> <68763.1215084867@turing-police.cc.vt.edu> <1215087695.10393.538.camel@pmac.infradead.org> <1215088905.9721.86.camel@linux.site> <1215089112.10393.544.camel@pmac.infradead.org>
            <1215090212.9721.91.camel@linux.site>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215093289_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 09:54:49 -0400
Message-ID: <76430.1215093289@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215093289_4193P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jul 2008 15:03:32 +0200, Kay Sievers said:
> On Thu, 2008-07-03 at 13:45 +0100, David Woodhouse wrote:
> > On Thu, 2008-07-03 at 14:41 +0200, Kay Sievers wrote:
> > > Headers are not needed for bootup, firmware might be. :) But /usr
> > > might be on a different partition/disk/storage at the time we need it,
> > > right?
> > > 
> > > I would say /usr/lib/firmware should not even exist, udev does
> > > intentionally not even look there.
> > 
> > Not /usr/lib/firmware. Currently, when you run 'make firmware_install',
> > it gets installed to usr/lib/firmware _within_ the kernel build
> > directory. And you're expected to copy it from there (or override with
> > 'make INSTALL_FW_PATH=/lib/firmware firmware_install')
> 
> Ah, ok. So by default "make modules_install" installs in the rootfs, but
> "make firmware_install" installs in the build directory? Hmm ...

The *odd* part is that make firmware_install isn't symmetric - it drops it
in $O/usr/lib/firmware, but you don't want the final result in /usr/lib,
you want it in /lib.  Maybe it should be dropping it in $O/lib/firmware
instead?

--==_Exmh_1215093289_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbNopcC3lWbTT17ARAl8bAJ9cfenyyZ+M7+zt7M1WBlNgFYdEYgCgok5u
7U3DayEBg7C0xGZDz/i06z0=
=/JeE
-----END PGP SIGNATURE-----

--==_Exmh_1215093289_4193P--
