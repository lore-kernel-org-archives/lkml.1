Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZFETWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZFETWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZFETWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:22:41 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43472 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZFETWk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:22:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: scripts/ver_linux lossage on Fedora 11
In-Reply-To: Your message of "Fri, 05 Jun 2009 14:59:53 EDT."
             <124717.1244228393@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <124717.1244228393@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1244229759_3985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 15:22:39 -0400
Message-ID: <132558.1244229759@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1244229759_3985P
Content-Type: text/plain; charset=us-ascii

On Fri, 05 Jun 2009 14:59:53 EDT, Valdis.Kletnieks@vt.edu said:

> +# older udev used this
>  udevinfo -V 2>&1 | grep version | awk '{print "udev                  ", $3}'
>  
> +# and newer use this
> +echo -n "udev                   "
> +udevadm --version
> +

Bah.  This blows chunks on boxes that have older udev and no udevadm.
Updated patch in the works....

Moral: Check caffienation levels *before* checking which boxes you tested on ;)

--==_Exmh_1244229759_3985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKKXB/cC3lWbTT17ARArNnAJ98PWpIGBmUd0sRl6tOSxDThOc/nACgo/VU
Gj7YUX4N7EP1qthyc8hFM+I=
=jBin
-----END PGP SIGNATURE-----

--==_Exmh_1244229759_3985P--
