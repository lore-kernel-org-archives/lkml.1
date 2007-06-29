Return-Path: <linux-kernel-owner+w=401wt.eu-S1765016AbXF2Oul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765016AbXF2Oul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXF2Oue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:50:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35190 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXF2Oud (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:50:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
In-Reply-To: Your message of "Thu, 28 Jun 2007 03:43:21 PDT."
             <20070628034321.38c9f12b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1183128630_3843P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Jun 2007 10:50:30 -0400
Message-ID: <6150.1183128630@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1183128630_3843P
Content-Type: text/plain; charset=us-ascii

On Thu, 28 Jun 2007 03:43:21 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/

Configures, builds, boots on first try.  Dell Latitude D820 laptop, T7200 CPU,
x86_64 kernel.  Doesn't break any of the out-of-tree stuff I use.

>   `make oldconfig', your kernel probably won't work.  I lost useful things
>   like CONFIG_BLK_DEV and the whole SCSI system, because they were added after
>   I generated my .config.

Odd - just for grins, I checked what 'make oldconfig' did when handed a .config
from 22-rc4-mm2, and it behaved just fine, much to my surprise.

I can't comment on the DMAR issues, my .config didn't include PCI_MSI so I never
got asked about that one by oldconfig.  Maybe if I get brave this afternoon. :)

--==_Exmh_1183128630_3843P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGhRw2cC3lWbTT17ARAmgSAKCZY4VD1su11L5FKoBmQswDGQ7qiQCgseiT
rM2JerAcVRgd6milRzv2ftE=
=Y9H1
-----END PGP SIGNATURE-----

--==_Exmh_1183128630_3843P--
