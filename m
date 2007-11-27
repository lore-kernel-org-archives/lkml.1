Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbXK0TvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbXK0TvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXK0TvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:51:14 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52666 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbXK0TvN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:51:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Michael Chan <mchan@broadcom.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-mm1 tg3 wake-on-lan oddity...
In-Reply-To: Your message of "Tue, 27 Nov 2007 08:04:28 PST."
             <1551EAE59135BE47B544934E30FC4FC002AABB51@nt-irva-0751.brcm.ad.broadcom.com>
From: Valdis.Kletnieks@vt.edu
References: <1551EAE59135BE47B544934E30FC4FC002AABB51@nt-irva-0751.brcm.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196193061_2895P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 14:51:01 -0500
Message-ID: <24595.1196193061@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196193061_2895P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Nov 2007 08:04:28 PST, Michael Chan said:
> Valdis.Kletnieks@vt.edu wrote:
> 
> > (a) the Dell factory default is WOL disabled and (b)
> > if it wasn't
> > the default, I'd have *set* it to disabled, and (c) I even
> > went back and
> > rebooted and checked the BIOS setting - disabled. Nonetheless:
> >
> > # ethtool eth0 | grep Wake
> >         Supports Wake-on: g
> >         Wake-on: g
> >
> > Is this expected behavior?
> >
> 
> The new tg3 is supposed to follow the WoL setting in the
> NVRAM, so this is not expected.  We'll have to look into
> this.

Any info that would help?  printk's to stick in tg3.c?  Dumping the
relevant bytes of NVRAM? etc?

--==_Exmh_1196193061_2895P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHTHUlcC3lWbTT17ARAmoEAKDSA4qr7IIBjgcYsx8wVJmGCDUBuACeNk06
NMMjb80hDgoMGeIJHA5X95Q=
=DTmY
-----END PGP SIGNATURE-----

--==_Exmh_1196193061_2895P--
