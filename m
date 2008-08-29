Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYH2NuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYH2NuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbYH2NuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:50:05 -0400
Received: from catarina.tagus.ist.utl.pt ([193.136.166.72]:52229 "EHLO
	mail.tagus.ist.utl.pt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756624AbYH2NuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:50:03 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 09:50:03 EDT
Date: Fri, 29 Aug 2008 14:43:20 +0100
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       494223@bugs.debian.org
Subject: Definition of PIM_REGISTER in pim.h, with more information
Message-ID: <20080829134319.GA8665@copernico.tagus.ist.utl.pt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jose Calhariz <jose.calhariz@tagus.ist.utl.pt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


I am sending this email again because I have more information.

----- Forwarded message from cal -----

To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Claudio Martins <ctpm@ist.utl.pt>,
	Jorge Daniel Sequeira Matias <martin@andorinha.ist.utl.pt>,
	javifs@gmail.com
Subject: Definition of PIM_REGISTER in pim.h


Hi.

About the new file linux/pim.h and the definitions of PIM in linux
2.6.26.=20

The "#define PIM_REGISTER 1" was in file mroute.h and was protected by
"#ifdef __KERNEL__" until version 2.5.25.  In version 2.6.26 this
define is in file pim.h but is no longer protected by a "#ifdef
__KERNEL__".

Is this change intentional? =20

This change breaks the compilation of software from the project
www.xorp.org.  In the file mrt/include/netinet/pim.h for the xorp
software they define PIM messages types and use this code:

/*
 * PIM message types
 */
#define PIM_HELLO               0x0     /* PIM-SM and PIM-DM            */

#define PIM_REGISTER            0x1     /* PIM-SM only                  */

#define PIM_REGISTER_STOP       0x2     /* PIM-SM only                  */
#define PIM_JOIN_PRUNE          0x3     /* PIM-SM and PIM-DM            */
#define PIM_BOOTSTRAP           0x4     /* PIM-SM only                  */
#define PIM_ASSERT              0x5     /* PIM-SM and PIM-DM            */
#define PIM_GRAFT               0x6     /* PIM-DM only                  */
#define PIM_GRAFT_ACK           0x7     /* PIM-DM only                  */
#define PIM_CAND_RP_ADV         0x8     /* PIM-SM only                  */
#define PIM_ALL_DF_ELECTION     0xa     /* Bidir-PIM-SM only            */

You can see the bug report with more details in:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D494223

I am one of the two persons that is packaging xorp for Debian. I am
talking in my personal name, not in the name of Debian, xorp project
or employer.  I am asking this to you because the problematic change
was possible introduced by:=20

commit 2e8046271f68198dd37451017c1a4a2432e4ec68
Author: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date:   Thu Apr 3 09:22:09 2008 +0900

    [IPV4] MROUTE: Move PIM definitions to <linux/pim.h>.
   =20
    Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>


I am free to give you more information if you need.  I am sorry if any
of my facts is wrong.

     Jos=E9 Calhariz

--------------

The bug report for xorp.org is in
http://bugzilla.xorp.org/bugzilla/show_bug.cgi?id=3D767 and they have
found a solution.  But I still believe the bug is on Linux Kernel
Headers.=20

     Jos=E9 Calhariz


--

As palavras enchem o espa=E7o. Eu prefiro encher a carteira

--Andy Warhol

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIt/z3Qlvqh9sPbBoRAk32AJ9npaqxhdjbCTi9hmstFjY3vztQ0QCgjk1z
Tool6AUxf5PVlVcA108Nv2c=
=Jwys
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
