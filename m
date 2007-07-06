Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbXGFLnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbXGFLnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXGFLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:43:36 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:33561 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758871AbXGFLnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:43:35 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Tejun Heo <htejun@gmail.com>
Subject: Re: SATA exceptions
Date: Fri, 6 Jul 2007 14:43:10 +0300
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <200707060046.13237.caglar@pardus.org.tr> <468DA071.9010605@gmail.com>
In-Reply-To: <468DA071.9010605@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4128241.6zHICuv4P7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061443.10991.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4128241.6zHICuv4P7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

06 Tem 2007 Cum tarihinde, Tejun Heo =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=
=B1:=20
> S.=C3=87a=C4=9Flar Onur wrote:
> > [ 4260.278427] ata1.00: cmd ca/00:08:d0:88:bc/00:00:00:00:00/ee tag 0 c=
db
> > 0x0 data 4096 out
> > [ 4260.278430]          res 51/40:01:d7:88:bc/00:00:0e:00:00/ee Emask 0=
x9
> > (media error)
>
> That's media error on sector 247236823 on WRITE.  Media errors on write
> are bad signs - it usually means the drive even failed to remap the
> sector because extra space ran out.=20

Hmm, more than 50GB is empty on disk :)

> I'm not sure this is the case here=20
> tho - the smart log is clear.  Please run smart short/long tests and see
> what they say.

Both completed without a problem;

zangetsu ~ # smartctl -l selftest /dev/sda
smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)=
 =20
LBA_of_first_error
# 1  Extended offline    Completed without error       00%       357       =
  -
# 2  Short offline       Completed without error       00%       355       =
  -

If you want me to try something else please just say :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart4128241.6zHICuv4P7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGjirOy7E6i0LKo6YRApJyAKDMUd6rbpzznSZMmopuMsqvCnt+NgCfRVUx
sXgR/QxlXR6r3UqWebdPDN8=
=ZySk
-----END PGP SIGNATURE-----

--nextPart4128241.6zHICuv4P7--
