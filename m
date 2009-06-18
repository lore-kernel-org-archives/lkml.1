Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZFRH22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZFRH22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbZFRH2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:28:08 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:40845 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbZFRH2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:28:06 -0400
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Thu, 18 Jun 2009 03:28:04 -0400
User-Agent: KMail/1.9.9
Cc: fmhess@users.sourceforge.net, Ian Abbott <abbotti@mev.co.uk>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>
References: <200906161701.45234.herton@mandriva.com.br> <200906172021.51400.fmhess@speakeasy.net> <200906172137.43870.herton@mandriva.com.br>
In-Reply-To: <200906172137.43870.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1430269.N1ItGMetJm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906180328.07976.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1430269.N1ItGMetJm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 17 June 2009, Herton Ronaldo Krzesinski wrote:
> >
> > Your patch breaks configuration of the board unless the bus and slot
> > are explicitly specified.  Just make a minimal patch that replaces
> > pci_get_device with pci_get_subsys and fixes the problem that was
> > reported.
>
> Hmm that's not what the patch does, it doesn't break configuration,
> keeps the same logic as before (I was wrong in my last email replying to
> myself), check it, if it->options[0] and it->options[1] isn't specified,
> the pdev is valid so the for loop exits (see !pdev check).

Your right.  However, it also turns a loop over pci devices into a loop=20
over pci ids, which appears to break the case of multiple s626 boards=20
where the bus/slot of the second s626 board is specified.  If you're not=20
willing to provide a minimal patch that just fixes the reported problem,=20
just say so.  It would have been less effort for me to do it myself than=20
analyze what your changes are breaking.


--nextPart1430269.N1ItGMetJm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKOeyF5vihyNWuA4URAqQEAKDAH7AapqoeHYl64m3ygr5IcwIpZQCeL4zm
QyK2/Pzry2QosR2pNL0mZfY=
=o3gv
-----END PGP SIGNATURE-----

--nextPart1430269.N1ItGMetJm--
