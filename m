Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZJZU3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZJZU3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZJZU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:29:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40039 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZJZU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:29:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bernhard Kaindl <bk@suse.de>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
In-Reply-To: Your message of "Mon, 26 Oct 2009 11:34:20 PDT."
             <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <4AE24009.4090408@gmail.com>
            <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256588976_3115P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Oct 2009 16:29:36 -0400
Message-ID: <21504.1256588976@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4AE606B1.01A5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256588976_3115P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Oct 2009 11:34:20 PDT, Justin Mattock said:

> I can't seem to locate a right mailing list
> for ieee1394 for Linux. Anyways here is a
> url to flickr which has the image of the PANIC:
> http://www.flickr.com/photos/44066293=40N08/4046711653/
> (hopefully you don't need to sign up to view)
>=20
> As for the problem, interesting thing here is if I add
> a printk to:
>=20
> if ((class =3D=3D 0xffffffff))
> printk(KERN_BUG =22init_ohci1394_dma: finished initializing OHCI DMA=5C=
n=22);
> continue; /* No device at this func */
>=20
> the system will boot-up, and the PANIC will not occur.

Note that just sticking a printk in there without a =7B =7D pair enclosin=
g
the printk and continue will change the semantics drastically - if the
conditional is true, it will do the printk instead of continuing. And
possibly more important, the continue just became unconditional.

What *exactly* does your code look like now?

--==_Exmh_1256588976_3115P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK5gawcC3lWbTT17ARAsPaAKCQObgycseS2ZwGCi4yMHblbVB0vQCg4cwh
JXzCIvlAyUELDrfGxgLGMhQ=
=NSH8
-----END PGP SIGNATURE-----

--==_Exmh_1256588976_3115P--

