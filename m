Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbZGIOo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbZGIOo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbZGIOoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:44:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41710 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760629AbZGIOoT (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:44:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Restricted Access Region Register driver for Intel MID devices
In-Reply-To: Your message of "Wed, 08 Jul 2009 13:00:12 PDT."
             <1247083212-17331-1-git-send-email-mark.a.allyn@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1247083212-17331-1-git-send-email-mark.a.allyn@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247148820_5710P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 10:13:40 -0400
Message-ID: <6766.1247148820@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247148820_5710P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Jul 2009 13:00:12 PDT, Mark Allyn said:
> This is the device driver for the Restricted Access Region registers on the
> Intel MID device.
> 
> Restricted Access Regions are areas of memory that are not accessable to the
> i86 processor.

This text should appear in the Kconfig entry down below.

'i86' - typo, or a new device that just looks like a typo?

> +++ b/drivers/rar_register/Kconfig
> @@ -0,0 +1,17 @@
> +#
> +# Serial device configuration
> +#
> +
> +menu "RAR Register Driver"
> +#
> +# The new 8250/16550 serial drivers
> +config RAR_REGISTER
> +	tristate "Restricted Access Region Register Driver"
> +	depends on MRST

Presumably, a yet-to-appear-in-my-inbox (but possibly in-flight) patch
will define this...

> +	default y
> +	---help---
> +		This driver allows other kernel drivers access to the
> +		contents of the restricted access region control 
> +		registers. 

As noted above, this should mention what chipset(s) these control registers
are found on.

--==_Exmh_1247148820_5710P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKVfsUcC3lWbTT17ARAqvbAJ9l6ncfKDvVpKSe7qVESD+p9oZRUACff2+a
h2cxeKE3lAcNtZpjtX3bMhY=
=IHXb
-----END PGP SIGNATURE-----

--==_Exmh_1247148820_5710P--
