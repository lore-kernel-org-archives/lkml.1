Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZJFDol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZJFDol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 23:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZJFDok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 23:44:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42821 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZJFDoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 23:44:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Cc: shawn.starr@rogers.com, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER DVD-RW DVR-111D
In-Reply-To: Your message of "Tue, 06 Oct 2009 00:15:48 +0200."
             <4aca7014.bWkj1S1Z6N2kt4dr%Joerg.Schilling@fokus.fraunhofer.de>
From: Valdis.Kletnieks@vt.edu
References: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de> <172428.1254779700@turing-police.cc.vt.edu>
            <4aca7014.bWkj1S1Z6N2kt4dr%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1254800635_3393P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 23:43:55 -0400
Message-ID: <188185.1254800635@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.35.168 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4ACABCFC.0152,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1254800635_3393P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Oct 2009 00:15:48 +0200, Joerg Schilling said:
>                                                        The fork did see=
=20
> some speudo activity in the time between september 2006 and May 6th 200=
7 but it
> is dead since then.

http://cdrkit.org/releases/ says differently:

=5B =5D	cdrkit-1.1.3.tar.gz	26-Mar-2007 20:38 	1.4M
=5B =5D	cdrkit-1.1.4.tgz	01-Apr-2007 20:12 	1.4M
=5B =5D	cdrkit-1.1.5.1.tar.gz	21-Apr-2007 09:54 	1.3M
=5B =5D	cdrkit-1.1.5.tar.gz	21-Apr-2007 09:24 	1.3M
=5B =5D	cdrkit-1.1.6.tar.gz	06-May-2007 15:44 	1.3M
=5B =5D	cdrkit-1.1.7.1.tar.gz	17-Mar-2008 21:47 	1.4M
=5B =5D	cdrkit-1.1.8.tar.gz	25-May-2008 23:02 	1.4M
=5B =5D	cdrkit-1.1.9.tar.gz	26-Oct-2008 23:17 	1.4M

Slow-moving maybe, but hardly =22dead=22.=20

> The fork is a problem caused by a hostile packetizer, see:

> http://cdrecord.berlios.de/private/linux-dist.html

Which says:

=22Although there is no =22project=22 activity on the =22fork=22 anymore =
since more than
28 months (which is more than three times of the speudo activity period),=
 there
are still people who spread incorrect claims on both the original project=
 and
the fork. Please help the free original project by correcting these incor=
rect
claims.=22

Unfortunately, =22there are still people who spread incorrect claims=22 s=
eems to
include one Joerg Schilling. Please fix your incorrect =2228 months=22 cl=
aim, and
all similar issues.  It will help your original project's credibility.

It also says:

=22In all programs of the fork that send SCSI commands, you may be unable=
 to
access any of the CD/DVD/Blu-Ray drives at all if you are on Linux-2.6.8.=
1 or
later. This is due to a missing workaround for the Linux kernel interface=

change that happened with Linux-2.6.8.1.=22

If this is the SCSI command filtering that was cleared up in 2.6.12, you
probably owe it to users to point out that little detail.  2.6.12 is over=
 4
years ago.  Given that when the fork happened, 2.6.17 was already current=
, I
could see why they didn't forward-port the fix for an issue that was only=
 a
problem then if your kernel was already more than 2 years old, and instea=
d just
put in doc/plattforms/README.linux:

 - Linux kernel versions between 2.6.8 and 2.6.11 are known to have invas=
ive
   SCSI command filtering which makes the use of wodim almost inpossible =
or
   complicated for non-root users. Avoid those kernel versions, unless th=
ey
   have been patched to disable that filtering.

So this claim, although possibly technically correct, is vastly misleadin=
g,
especially 4 years later.

> You can help: Ask your Linux distributor why he distributes an illegal =
and=20
> buggy fork instead of the legal original software=21

Apparently it's distributed because their legal team doesn't think it's a=
n
illegal fork, and it's still buggy because after you relicensed to CDDL, =
they
felt they couldn't backport your fixes to the original GPL code.

--==_Exmh_1254800635_3393P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKyrz7cC3lWbTT17ARAhCaAJ9+AE7fkPhgUuqSZDdgu1GsAsyM1wCg+zSa
MQefsS2ikWs+ntxtd5dZaoQ=
=0wIR
-----END PGP SIGNATURE-----

--==_Exmh_1254800635_3393P--

