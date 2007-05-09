Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbXEIO56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbXEIO56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXEIO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:57:51 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54609 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXEIO5v (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:57:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - Kconfig horkage
In-Reply-To: Your message of "Wed, 09 May 2007 01:23:22 PDT."
             <20070509012322.199f292b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178722647_3193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 May 2007 10:57:27 -0400
Message-ID: <5713.1178722647@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178722647_3193P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/

1) Spotted in init/Kconfig:

config SLUB_DEBUG
        default y
        bool "Enable SLUB debugging support" if EMBEDDED
        help

Shouldn't that have an 'default SLUB' or 'if SLUB' or something attached to it?

2) In drivers/media/Kconfig we see:

config DAB
        boolean "DAB adapters"
        default y
        ---help---
          Allow selecting support for for Digital Audio Broadcasting (DAB)
          Receiver adapters.

Should that be 'default N'?




--==_Exmh_1178722647_3193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQeFXcC3lWbTT17ARAubcAJwOsU1IWkbQpvQTVCB/b9V1IVGVkgCg/NMh
P+4TazdHBjUK5pjEjGmEsN8=
=alze
-----END PGP SIGNATURE-----

--==_Exmh_1178722647_3193P--
