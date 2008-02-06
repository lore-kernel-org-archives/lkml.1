Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbYBFCGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbYBFCGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbYBFCGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:06:40 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50340 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029AbYBFCGk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:06:40 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] stop c_p_a corrupting the pds
In-Reply-To: Your message of "Tue, 05 Feb 2008 22:27:21 GMT."
             <Pine.LNX.4.64.0802052226140.11822@blonde.site>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0802052218190.11822@blonde.site>
            <Pine.LNX.4.64.0802052226140.11822@blonde.site>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1202263535_3253P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2008 21:05:35 -0500
Message-ID: <26590.1202263535@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1202263535_3253P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Feb 2008 22:27:21 GMT, Hugh Dickins said:
> When change_page_attr splits a large page on x86_32 (without PAE), it is
> currently corrupting every process's page directory: fix that by removing
> the thinko which passes down a physical instead of a virtual address -
> this version of the patch being the hotfix for 2.6.24-mm1.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

<snark>
I *knew* there was a reason we should have had this patch series in -mm for a while.
</snark>

:)

--==_Exmh_1202263535_3253P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHqRXvcC3lWbTT17ARAitGAKCmRR7pkMfJ3Txpcx2bzGqO4Ux8+gCfWTCL
RaoFS4dfanoetkoqdB3QqWo=
=eg+5
-----END PGP SIGNATURE-----

--==_Exmh_1202263535_3253P--
