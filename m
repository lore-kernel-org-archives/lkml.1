Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbXHAUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbXHAUa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXHAUaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:30:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35918 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXHAUaM (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:30:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
In-Reply-To: Your message of "Tue, 31 Jul 2007 23:09:32 PDT."
             <20070731230932.a9459617.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070731230932.a9459617.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186000208_3775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Aug 2007 16:30:08 -0400
Message-ID: <12639.1186000208@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186000208_3775P
Content-Type: text/plain; charset=us-ascii

On Tue, 31 Jul 2007 23:09:32 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/

Builds, boots, runs here. Dell Latitude D820, Core2 Duo T7200, x86_64 kernel.

> -loop-use-unlocked_ioctl.patch
> 
>  Dropped, broken.

Fixes one issue I had in -mm1 (I'm assuming somebody else spotting this one
as well, you dropped it before I reported it.. :)

> +tpm_tis-fix-interrupt-probing.patch

And the other...

As an aside, it looks like bits&pieces of dynticks-for-x86_64 are in there.
In particular, x86_64-enable-high-resolution-timers-and-dynticks.patch is in
there, adding a menu that depends on GENERIC_CLOCKEVENTS, but then nothing
in the x86_64 tree actually *sets* it.  There's a few other dynticks-related
prep patches in there as well.  Does this mean it's back to "coming soon to
a CPU near you" status? :)

--==_Exmh_1186000208_3775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGsO1QcC3lWbTT17ARAjchAJ9d3ovh3T+AlndvORSp5BpHjt+NRgCgqon4
ekLqCo0gZDe7tH84U/LJ00E=
=BdDF
-----END PGP SIGNATURE-----

--==_Exmh_1186000208_3775P--
