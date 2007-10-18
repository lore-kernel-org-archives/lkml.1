Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbXJRF6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbXJRF6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXJRF6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:58:01 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:60723 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXJRF6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:58:00 -0400
Date: Thu, 18 Oct 2007 09:57:55 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071018055755.GA9561@pazke.donpac.ru>
Mail-Followup-To: Chris Bergeron <chris@pcburn.com>,
	linux-kernel@vger.kernel.org
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <471689DA.4070008@pcburn.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 290, 10 17, 2007 at 06:16:58 -0400, Chris Bergeron wrote:
> Andrey Panin wrote:
>>
>> Is it possible to connect two ports and run getty on one port and minico=
m=20
>> on
>> another ? We should check that UARTs are really working.
>>
>>  =20
> I used the on-board serial port as a known working control (after getting=
=20
> it to work with the other onboard serial port) to try and connect over to=
=20
> one of the Syba card ports (using Cutecom & getty).  The lines light up,=
=20
> but there's nothing getting sent from the 8-port as far as I can see.

Oh crap... I missed this fscking "Disabling IRQ #17" line in your dmesg.
Can you try with firewire controller disabled somehow ?

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHFvXjIWZCBzwS8mkRAo0JAJwLdZ0Gp2p1biJUQrSjmNeGu1cvogCfThG/
tzpSmgfU8DPCyvFA2HQne5k=
=au1I
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
