Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYJAKNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYJAKNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYJAKN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:13:26 -0400
Received: from mx40.mail.ru ([194.67.23.36]:53337 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYJAKNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:13:25 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Greg KH <greg@kroah.com>
Subject: Re: Building two (external) modules from the same sources
Date: Wed, 1 Oct 2008 14:13:10 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, TJ <tj@tjworld.net>,
       "Casual J. Programmer" <casualprogrammer@googlemail.com>
References: <200809290949.35749.arvidjaar@mail.ru> <20081001031907.GA19181@kroah.com>
In-Reply-To: <20081001031907.GA19181@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8615898.RlTIFPApKq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810011413.17059.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8615898.RlTIFPApKq
Content-Type: multipart/mixed;
  boundary="Boundary-01=_4004ItAPOX4Qzpv"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_4004ItAPOX4Qzpv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 October 2008, Greg KH wrote:
> On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
> > I have here driver that can be built for two different types of
> > hardware from basically the same sources (this is port of old Agere
> > drivers for Hermes-I/Hermes-II chipsets).
>=20
> Cool, do you have a link to the code, I'd be glad to add it to
> drivers/staging/ if it's not in a fully-mergable state yet to get wider
> users for it.
>=20

You can look at it here: http://arvidjaar.newmail.ru/wlags49.tar.bz

I doubt that it is suitable for inclusion at current state if ever.
This is taken directly from Agere 2.4 sources; the only parts that were
touched are kernel glue and wireless extensions interface.

And it is not GPL'ed, of course. I attach E-Mail I received a while
back with answere from Agere legal department.

I know that (rather unexpectedly) driver got some acceptance and I was
approached several times by different people; I Cc to them.

> > Build differs only in one define -DHERMES2 and single file with
> > different firmware. Unfortunately "if HII" are spread over sources
> > which makes splitting of sources rather questionable.
> >=20
> > What is the best way (from kbuild POV) to build two modules - for H-I
> > and H-II - from the same set of source files?
>=20
> Not to create two different modules, but rather have one module that
> works for both pieces of hardware, with dynamic checks for the different
> portions.
>=20

I can't; one of the reasons being - I have no idea how to do it. Original
sources build separate modules for every flavour of driver. It is just that
I was recently asked about this driver on Zaurus (which happens to use
Hermes-II); so I had to do something about it.

If someone could offer (link to) hermes-1/2 programming manual ...

--Boundary-01=_4004ItAPOX4Qzpv
Content-Type: message/rfc822;
  name="Re: wlags49_h1_cs - 2.6.x - Agere Hermes I driver"
Content-Transfer-Encoding: 7bit
Content-Description: TJ <tj@tjworld.net>: Re: wlags49_h1_cs - 2.6.x - Agere Hermes I driver
Content-Disposition: inline;
	filename="Re: wlags49_h1_cs - 2.6.x - Agere Hermes I driver"

Return-path: <tj@tjworld.net>
Received: from [84.12.34.246] (port=48494 helo=phwoarrr.tv)
	by mx23.mail.ru with esmtp 
	id 1HE9WP-000Ecs-00
	for arvidjaar@mail.ru; Mon, 05 Feb 2007 22:29:01 +0300
Received-SPF: none (mx23.mail.ru: 84.12.34.246 is neither permitted nor denied by domain of tjworld.net) client-ip=84.12.34.246; envelope-from=tj@tjworld.net; helo=phwoarrr.tv;
Received: from [84.12.34.243] (unverified [84.12.34.243]) 
	by phwoarrr.net (SurgeMail 3.7b6) with ESMTP id 8170 
	for <arvidjaar@mail.ru>; Mon, 05 Feb 2007 19:29:00 +0 GMT
Subject: Re: wlags49_h1_cs - 2.6.x - Agere Hermes I driver
From: TJ <tj@tjworld.net>
To: Andrey Borzenkov <arvidjaar@mail.ru>
In-Reply-To: <200701192041.45312.arvidjaar@mail.ru>
References: <456706E8.1080107@tjworld.net>
	 <200611251214.19303.arvidjaar@mail.ru>
	 <1169180283.18068.2.camel@butch.lan.tjworld.net>
	 <200701192041.45312.arvidjaar@mail.ru>
Content-Type: text/plain
Organization: TJworld
Date: Mon, 05 Feb 2007 19:28:59 +0000
Message-Id: <1170703739.10363.9.camel@butch.lan.tjworld.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-Server: High Performance Mail Server - http://surgemail.com r=-2006397171
X-Authenticated-User: tj@tjworld.net 
X-DNS-Paranoid: DNS lookup didn't match (84.12.34.243)->(dns2.hornytunes.com)->()
X-Spam: Not detected

Hi Andrey,

I've got some good news for you/us/the world of Hermes :)

I got a reply from the legal representative at Agere confirming that
their source-code is BSD licensed, and I've included the contents of the
email here.

I hope this re-assures you so that your excellent work on the drivers
can be made widely available for other hackers to work with.

Regards,

TJ.

---------
On Mon, 2007-02-05 at 13:54 -0500, Pathare, Viren M (Viren) wrote:


"I would like to confirm that the two drivers; Linux LKM Wireless Driver
Source Code, Version 7.18 and Linux LKM Wireless Driver Source Code,
Version 7.22 comply with Open Source BSD License. Therefore the source
code can be distributed in unmodified or modified form consistent with
the terms of the license.

The Linux driver architecture was based on two modules, the MSF (Module
specific functions) and the HCF (Hardware Control Functions).  Included
in the HCF is run-time firmware (binary format) which is downloaded into
the RAM of the Hermes 1/2/2.5 WMAC.

This hex coded firmware is not based on any open source software and
hence it is not subject to any Open Source License.  The firmware was
developed by Agere and runs on the DISC processor embedded within the
Hermes 1/2/2.5 Wireless MAC devices. 

Hope this helps.

Sincerely,

Viren Pathare
Intellectual Property Licensing Manager
Agere"



--Boundary-01=_4004ItAPOX4Qzpv--

--nextPart8615898.RlTIFPApKq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjjTTgACgkQR6LMutpd94wK5wCffyjLSQ+NKyOjANL101wCdXKv
EzwAn0rnmJ58zDVR6XaXmUSr+c+PAgJP
=zRCB
-----END PGP SIGNATURE-----

--nextPart8615898.RlTIFPApKq--
