Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZJEVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZJEVzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZJEVzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:55:52 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56050 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZJEVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:55:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Cc: linux-kernel@vger.kernel.org, shawn.starr@rogers.com
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER DVD-RW DVR-111D
In-Reply-To: Your message of "Mon, 05 Oct 2009 13:11:51 +0200."
             <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de>
From: Valdis.Kletnieks@vt.edu
References: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1254779700_3393P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 17:55:00 -0400
Message-ID: <172428.1254779700@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.35.168 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4ACA6B3E.0143,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1254779700_3393P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Oct 2009 13:11:51 +0200, Joerg Schilling said:
> >Model is:=20
> >Unable to burn DVDs with 2.6.31.x
>=20
> >ata7.00: ATAPI: PIONEER DVD-RW  DVR-111D, 1.29, max UDMA/66
> >scsi 6:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.29 PQ: 0 A=
NSI: 5
>=20
> >sr 6:0:0:0: =5Bsr0=5D Unhandled sense code                            =
                                           =20

> Please note that this is not cdrecord but a defective fork where someon=
e

Please note that it doesn't matter if it's Joerg's Officially Blessed Cdr=
ecord
or not - the question is if userspace should be able to cause that error
to happen  *at all*.

Also, it's quite possible that we're looking at a *kernel* regression, th=
at
the userspace software managed to actually *work* with previous kernels, =
even
if it wasn't blessed by you:

>> I thought maybe this was due to something with kernel config but I'm n=
ot sure
>> now. This used to work fine.

If it breaks when somebody upgrades their kernel, it's probably the kerne=
l's
fault, not the user's fault for using a distro that ships The Other Fork.=


> It is very likely that this problem does not occur with the original
> cdrecord from:

> ftp://ftp.berlios.de/pub/cdrecord/alpha/

Yes, but his distro probably feels it can't ship the original cdrecord
so it ships wodim instead.  And if it's indeed a kernel bug, replacing
a forked userspace program to work around a kernel bug is The Wrong Answe=
r.

It forked 3 whole years ago, Joerg.  Let it go already. And if you can't
let it go, at least ask the user *helpful* questions, like Jeff Garzik di=
d:

> Can you post full dmesg output?  And you have verified that vanilla=20
> 2.6.30 kernel works OK?


--==_Exmh_1254779700_3393P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKyms0cC3lWbTT17ARAqFmAKDy7WQxhYOgu8qQueGFCBfdP9KAKwCg68HI
cQFcN889KcqItio6492jb80=
=nl39
-----END PGP SIGNATURE-----

--==_Exmh_1254779700_3393P--

