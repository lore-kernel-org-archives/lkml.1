Return-Path: <linux-kernel-owner+w=401wt.eu-S1767148AbXDERi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767148AbXDERi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767149AbXDERi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:38:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51275 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767148AbXDERiZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:38:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
In-Reply-To: Your message of "Thu, 05 Apr 2007 11:44:46 BST."
             <1175769886.10382.29.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <1175769886.10382.29.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175794703_8618P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Apr 2007 13:38:23 -0400
Message-ID: <8776.1175794703@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175794703_8618P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Apr 2007 11:44:46 BST, Alan Hourihane said:

> Attached is a patch against 2.6.21-rc5 which adds the Intel Vermilion
> Range support.

One non-technical question here...

> +config FB_VERMILION
> +	tristate "Vermilion support"
> +	depends on FB && PCI && X86
> +	select FB_MODE_HELPERS
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	help
> +	  This driver supports the Vermilion Range chipset

Is 'Vermillion' the project codename, or the name that end users will actually
see when hardware ships?  Most of the Intel graphics chopsets have been
named things like i810, i925, and so on - if the user-visible name is known,
that should probably be reflected in the 'tristate' string and help
text (FB_VERMILLION in the code is fine by be though).


--==_Exmh_1175794703_8618P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFTQPcC3lWbTT17ARArRWAJ9f9LyS3sosemmIFVslUDtJTOqCZACgmlX6
SJyj89mJx+Tkyfl7CsknB+Y=
=w9UF
-----END PGP SIGNATURE-----

--==_Exmh_1175794703_8618P--
