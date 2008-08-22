Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYHVRKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYHVRKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYHVRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:10:00 -0400
Received: from mx71.mail.ru ([194.67.23.4]:64389 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYHVRKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:10:00 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
Date: Fri, 22 Aug 2008 21:09:53 +0400
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <200808222026.25944.arvidjaar@mail.ru> <200808222053.09066.arvidjaar@mail.ru> <200808221904.04773.rjw@sisk.pl>
In-Reply-To: <200808221904.04773.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3238344.Hm86jHa3B4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808222109.55358.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3238344.Hm86jHa3B4
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 22 August 2008, Rafael J. Wysocki wrote:
> On Friday, 22 of August 2008, Andrey Borzenkov wrote:
> > On Friday 22 August 2008, Andrey Borzenkov wrote:
> > >=20
> > > 2.6.26-rc3 is OK
>=20
> Thanks for the report, but ...
> =20
> > > top - 20:11:08 up 5 min,  1 user,  load average: 7.05, 4.50, 1.93
> > > Tasks: 103 total,   3 running, 100 sleeping,   0 stopped,   0 zombie
> > > Cpu(s):  8.3%us, 91.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si=
,  0.0%st
> > > Mem:    494172k total,   278192k used,   215980k free,    18264k buff=
ers
> > > Swap:   500432k total,        0k used,   500432k free,   159376k cach=
ed
> > >=20
> > >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > >   851 root      15  -5     0    0    0 R 65.6  0.0   3:21.16 khubd
> >=20
> > reverting 38b375d9610e2467cb793a84d17c6f65e44cdb39 fixed it
> >=20
>=20
> ... that is:
>=20
> commit 38b375d9610e2467cb793a84d17c6f65e44cdb39
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Mon Jul 21 09:56:26 2008 -0400
>=20
>     USB: OHCI: fix system hang caused by earlier patch
>=20
>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>     Tested by: Andrey Borzenkov <arvidjaar@mail.ru>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> so it apparently used to work for you at that time.  What gives?
>=20

Well, you should not commit a fix without commiting code that has been
fixed first :)

--nextPart3238344.Hm86jHa3B4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiu8uMACgkQR6LMutpd94zDAwCgtGGJd1Y5P/7lzta4JQhRX94w
nW0AoMgnMxjXSrNNG+VE/5SaQS+CHQht
=aAWv
-----END PGP SIGNATURE-----

--nextPart3238344.Hm86jHa3B4--
