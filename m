Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbXK0HzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbXK0HzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXK0HzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:55:04 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50922 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbXK0HzC (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:55:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 - brick my Dell Latitude D820
In-Reply-To: Your message of "Mon, 26 Nov 2007 23:27:03 PST."
             <20071126232703.c956addc.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4210.1196147786@turing-police.cc.vt.edu>
            <20071126232703.c956addc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196150096_2790P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 02:54:56 -0500
Message-ID: <6421.1196150096@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196150096_2790P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Nov 2007 23:27:03 PST, Andrew Morton said:

> > git-x86.patch
> > git-x86-fixup.patch
> > git-x86-thread_order-borkage.patch
> > git-x86-thread_order-borkage-fix.patch
> > git-x86-identify_cpu-fix.patch
> > git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
> > git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
> > git-x86-inlining-borkage.patch
> > x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
> > x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch BAD

> You could try http://userweb.kernel.org/~akpm/mmotm/ - we might have already
> fixed it.

I suspect that trying -rc3-mm1 but refreshing just the 10 patches above
from -mmotm would be far less likely to pull in other heartburn?

> Otherwise, please proceed to work out which diff I need to drop and hope like
> hell that it isn't git-x86..

That's a 41,240 line diff, the rest *total* to about 400 lines.  I don't have
warm-n-fuzzies about my odds here. ;)

I'm a git-idiot, but *do* know how to git-bisect through Linus tree - what
would I need to do to git-bisect through git-x86.patch? (I do *not* know how
to deal with more than 1 source git tree, so if the magic is just 'get a
linus tree, merge git-x86, then bisect as usual", I'm stuck on "merge git-x86")..


--==_Exmh_1196150096_2790P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS81QcC3lWbTT17ARAqXqAJ9Bvg3XtirNpUAf+y50k53GQSQnMACfahdr
X0XsWXANM2MDLUCzqx0G0mE=
=mx/v
-----END PGP SIGNATURE-----

--==_Exmh_1196150096_2790P--
