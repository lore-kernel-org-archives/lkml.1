Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbXHFWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbXHFWj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbXHFWjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:39:18 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:60152 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761240AbXHFWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:39:17 -0400
X-Greylist: delayed 2470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 18:39:17 EDT
Date: Mon, 6 Aug 2007 23:57:52 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: =?UTF-8?Q?Rafa=C5=82?= Bilski <rafalbilski@interia.pl>
Cc: Andreas Mohr <andi@lisas.de>, David Edwards <powertop@dpe.lusars.net>,
       power@bughost.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
Message-ID: <20070806235752.1e6c5653@laptop.hypervisor.org>
In-Reply-To: <46B79512.6090704@interia.pl>
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
	<46B79512.6090704@interia.pl>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_8xtzqQ+aMps5wZyMSKWGe5q;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_8xtzqQ+aMps5wZyMSKWGe5q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Aug 2007 23:39:30 +0200 Rafa=C5=82 Bilski (RB) wrote:

RB> VT8235 does *NOT* have a HPET(*). Only part which has HPET is VT8237. It
RB> is device 00:17.0 too, but only 1106:3227 has HPET enable and memory
RB> base registers. VT8235 one and only feature which doesn't have driver
RB> yet seems to be hardware watchdog.
RB> (*) Datasheet revision 2.03 March 16, 2005

We have an Asrock K7VT4A+ board with VT8235 southbridge in our lab and it
does have an HPET. Just because the datasheet does not document HPET does
not mean it is not implemented.

My guess is that newer revisions of VT8235 have HPET whereas older revisions
do not. I'll get an lspci dump from our box tomorrow.

Cheers,

	- Udo

--Sig_8xtzqQ+aMps5wZyMSKWGe5q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGt5lgnhRzXSM7nSkRAlL/AJ0QqeuCkwZu7V4420qKGmQNd4/frgCfbniR
PfXF3KET355qejx6IIqW3cY=
=QiGs
-----END PGP SIGNATURE-----

--Sig_8xtzqQ+aMps5wZyMSKWGe5q--
