Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbXFBBoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbXFBBoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbXFBBn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:43:57 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:44685 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbXFBBn4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:43:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrey Vul <andrey.vul@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: tickless timer support on non-x86
In-Reply-To: Your message of "Fri, 01 Jun 2007 18:20:02 EDT."
             <e38d12ff0706011520n4d6f00cdt80a4ead3d939c849@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <e38d12ff0706011520n4d6f00cdt80a4ead3d939c849@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180748634_4213P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Jun 2007 21:43:54 -0400
Message-ID: <8461.1180748634@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180748634_4213P
Content-Type: text/plain; charset=us-ascii

On Fri, 01 Jun 2007 18:20:02 EDT, Andrey Vul said:
> I want to use the tickless timer features in 2.6.21, but
> unfortunately, the dependency for tickless timers is
> GENERIC_CLOCKEVENTS (and tickless is only in arch/i386).
> 
> Any workarounds or solutions for non-x86 people?
> 
> My CPU is AMD Turion ML-34.

If that AMD is running a 32-bit kernel, the code already in the kernel
should work just fine (barring hardware issues like busticated HPET/timer
and so on).  If it doesn't work, we should debug that issue.

If you're running a 64-bit kernel, you might want to check here:

http://www.tglx.de/projects/hrtimers/

The 2.6.22-rc3-hrt2 patch series can be 'quilt'ed onto a -rc3-mmm1 tree
with about 20 minutes of work fixing a few trivial rejects (2 or 3 patches
already in -mm, and another 2 or 3 trivial rejectts...)

--==_Exmh_1180748634_4213P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYMtacC3lWbTT17ARAttwAKCKLpgHDLhV7B3V21GEvJ7de1Km2wCfamVK
owVV36zydFkjynnevC/5Z/A=
=6sbZ
-----END PGP SIGNATURE-----

--==_Exmh_1180748634_4213P--
