Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYB2Qg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYB2Qg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYB2Qgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:36:49 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53502 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYB2Qgs (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:36:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit sources
In-Reply-To: Your message of "Fri, 29 Feb 2008 11:25:58 EST."
             <Pine.LNX.4.61.0802291123280.23162@chaos.analogic.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.61.0802290954390.22942@chaos.analogic.com> <Pine.LNX.4.64.0802291631020.24056@fbirervta.pbzchgretzou.qr>
            <Pine.LNX.4.61.0802291123280.23162@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204303003_3290P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Feb 2008 11:36:43 -0500
Message-ID: <28962.1204303003@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204303003_3290P
Content-Type: text/plain; charset=us-ascii

On Fri, 29 Feb 2008 11:25:58 EST, "linux-os (Dick Johnson)" said:
> 
> Yes. The RPM contains only patches and the patches won't
> patch a 2.6.11 kernel either! Perhaps they need to be
> in some undefined order.

Umm... I just checked that specific RPM, and that RPM *does* contain all that
you need. In particular, the following *are* in there:

kernel-2.6.spec
linux-2.6.11.tar.bz2
patch-2.6.12-rc5-neutered.bz2  <- probably why they won't patch a 2.6.11

The spec file lists all the *.patch files and the order to apply them in.  It
even has a whole bunch of *.config files.

Your best best is to 'rpm -ivh' that RPM - that will put the pieces in
/usr/src/redhat/SOURCES and /usr/src/redhat/SPECS.  'rpmbuild kernel.spec'
(with appropriate flags, you probably want '--target x86_64' if you want
a  64-bit build only).  Adding patches is a matter of dropping the patch in
/usr/src/redhat/SOURCES and adding a few lines to the kernel-2.6.spec file.



--==_Exmh_1204303003_3290P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHyDSbcC3lWbTT17ARAgSPAJ9wcUAXI9zYGmV0L2IlvyGz+FfgiQCfeX8G
EvlN4gvoPqdRfRXoRvd5Hu4=
=XA7R
-----END PGP SIGNATURE-----

--==_Exmh_1204303003_3290P--
