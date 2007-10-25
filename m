Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXJYKXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXJYKXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbXJYKXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:23:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51811 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXJYKXY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:23:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Giacomo Catenazzi <cate@debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: Your message of "Tue, 23 Oct 2007 10:34:09 CDT."
             <20071023153409.GA14215@vino.hallyn.com>
From: Valdis.Kletnieks@vt.edu
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <471D8A4C.3020101@debian.org> <Pine.LNX.4.64.0710231051090.16684@fbirervta.pbzchgretzou.qr> <20071023152005.GA13767@vino.hallyn.com> <Pine.LNX.4.64.0710231725550.16684@fbirervta.pbzchgretzou.qr>
            <20071023153409.GA14215@vino.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1193307789_2831P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2007 06:23:09 -0400
Message-ID: <5541.1193307789@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1193307789_2831P
Content-Type: text/plain; charset=us-ascii

On Tue, 23 Oct 2007 10:34:09 CDT, "Serge E. Hallyn" said:

> And he will still be able to *run* the suid binary, but if cap_bound is
> reduced he won't be able to use capabilities taken out of the bounding
> set, multiadm loaded or not.

I am willing to bet that there's still a *lot* of unaudited set[ug]id code
out there that's vulnerable to the same sorts of attacks as the one that
hit Sendmail a few back.  As such, I have to agree with your original
post of the patch that CAP_SYS_ADMIN should be required to lower the set,
as there's just too much danger of an exploit if users can create their
own reduced-set processes.

I'm debating whether we should have a printk if we detect that a removed
capability caused an -EPERM.  Yes, it can be used to spam the logs.  On the
other hand, I as the sysadmin would like to know if it's happening. Looks like
time for a sysctl or something....

--==_Exmh_1193307789_2831P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHIG6NcC3lWbTT17ARAga4AJ9tP5AhJ0tcET6g1JWjes8ADhk/YwCfTSic
75TqSZsB72Dk4mE9DaxuJBA=
=SSEX
-----END PGP SIGNATURE-----

--==_Exmh_1193307789_2831P--
