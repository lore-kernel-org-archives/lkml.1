Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXGITIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXGITIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXGITHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:07:55 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49280 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754278AbXGITHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:07:54 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Tejun Heo <htejun@gmail.com>
Subject: Re: SATA exceptions
Date: Mon, 9 Jul 2007 22:06:36 +0300
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Onur =?utf-8?q?K=C3=BC=C3=A7=C3=BCk?= <onur@pardus.org.tr>,
       =?utf-8?q?=C4=B0smail_D=C3=B6nmez?= <ismail@pardus.org.tr>
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <200707080035.05718.caglar@pardus.org.tr> <46928066.7000705@gmail.com>
In-Reply-To: <46928066.7000705@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2093047.xOZHTgb59X";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707092206.37456.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2093047.xOZHTgb59X
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

09 Tem 2007 Pts tarihinde, Tejun Heo =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=
=B1:=20
> > 07 Tem 2007 Cts tarihinde, Robert Hancock =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:
> >> It's not the free space on the drive that matters, it's the number of
> >> free sectors in the spare sector pool on the drive, which is invisible
> >> to software.
> >>
> >> Your SMART log shows 309 reallocated sectors. That seems somewhat high=
=2E.
> >
> > Ah sorry to misinterpret the content:), its a quiet new piece of hardwa=
re
> > (at most ~1.5 month old) and  "Reallocated_Event_Count" constantly
> > increases (currently its increased to 313) and although i'm not 100
> > percent sure these errors only occured with kernels > 2.6.18 (or 2.6.18
> > didn't report these cause according to kern.log these only visible with
> > 2.6.22+)
>
> OS and driver can't really do much about the reallocation event.  Some
> number of reallocations is okay but if you it going up constantly, you
> probably have a dying disk.

Hmm its really interesting, then it means 3 piece of ~1.5 month old laptops=
=20
dieing for same decease :) or they already somehow defectived (or we are=20
damaging them but it sits on my table happily all that time :P)

> > We bought 3 HP Pavillon dv2385ea and one of them only runs with 2.6.18
> > and its smartctl output follows as a reference;
> >
> >   5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail
> > 196 Reallocated_Event_Count 0x0032   253   253   000    Old_age
>
> Hmm... This is pretty high too.  Do the counts increase on this machine
> too?

Yes, seems so (i'm adding Onur and =C4=B0smail to CC as other machines owne=
r) and=20
here is the smart logs for this 3 seperate machine, its interesting me and=
=20
=C4=B0smail runs  2.6.22 (over 300 reloacations occured for both of us) and=
 Onur=20
uses 2.6.18 (0 relocation occured for him)

[1] http://cekirdek.pardus.org.tr/~caglar/SATA/smart.caglar
[2] http://cekirdek.pardus.org.tr/~caglar/SATA/smart.ismail
[3] http://cekirdek.pardus.org.tr/~caglar/SATA/smart.onur

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2093047.xOZHTgb59X
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGkoc8y7E6i0LKo6YRAt4RAJ9v5h68Nu74czyorFu2HFWR74NxrQCgyIV4
LESifAjZcTkAGv0E57YhJZM=
=seIU
-----END PGP SIGNATURE-----

--nextPart2093047.xOZHTgb59X--
