Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299Ab0ALAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0ALAV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443Ab0ALAV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:21:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41409 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0ALAV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:21:26 -0500
Date: Tue, 12 Jan 2010 11:21:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: Can we remove pci_find_device() yet?
Message-Id: <20100112112115.98009d50.sfr@canb.auug.org.au>
In-Reply-To: <20100111200136.GA29955@suse.de>
References: <20100108112236.462a3da2.sfr@canb.auug.org.au>
	<20100108044646.GC6611@suse.de>
	<4B4B802A.2010709@imap.cc>
	<20100111200136.GA29955@suse.de>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Jan_2010_11_21_15_+1100_wPfjVLs1zsoYD1mn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jan_2010_11_21_15_+1100_wPfjVLs1zsoYD1mn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 11 Jan 2010 12:01:36 -0800 Greg KH <gregkh@suse.de> wrote:
>
> Close, but if you do this, please name the function
> hisax_find_pci_device() or something, and change the drivers to use it
> instead.  Also put a big fat warning in the function that calling this
> is unsafe for any PCI hotplug type machine.

There is another implementation of pci_find_device in
drivers/staging/dt3155/pci-compat.h (used by dt3155_drv.c).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Jan_2010_11_21_15_+1100_wPfjVLs1zsoYD1mn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktLwHwACgkQjjKRsyhoI8zRiACfR+S4tL9GTzsSUPl9trNgRAfE
BZYAn2oluFkU/kwDvE0CQZK3mqriNyML
=lmE1
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jan_2010_11_21_15_+1100_wPfjVLs1zsoYD1mn--
