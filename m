Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZHNSNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZHNSNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZHNSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:13:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48844 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbZHNSNG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:13:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] X86: Fix x86_cache_size value
In-Reply-To: Your message of "Fri, 14 Aug 2009 16:03:56 +0530."
             <1250246036.9062.5.camel@ht.satnam>
From: Valdis.Kletnieks@vt.edu
References: <1250245149.9062.3.camel@ht.satnam>
            <1250246036.9062.5.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1250273356_9206P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Aug 2009 14:09:16 -0400
Message-ID: <25944.1250273356@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1250273356_9206P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Aug 2009 16:03:56 +0530, Jaswinder Singh Rajput said:
> Currently x86_cache_size is showing partial value: L1 or L2 or L3.
> It should add all caches like L1 + L2 + L3 + Trace.

*Why* should it?  Adding the L1 cache probably makes little or no difference
when the L2/L3 caches are usually so much larger (on my laptop, there's a
whole whopping 32K of L1, but 4M of L2 and no L3). It *might* make sense
to report L2+L3.  It would depend on who uses that number, and for what.

But adding the trace cache is just batshit crazy.

--==_Exmh_1250273356_9206P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKhahMcC3lWbTT17ARApozAJ4lOn55F3z8JhHDUWGIZLs/JKHZeQCgxr8y
xV8hnv/zoxfIS8OM199YLHM=
=IJZz
-----END PGP SIGNATURE-----

--==_Exmh_1250273356_9206P--
