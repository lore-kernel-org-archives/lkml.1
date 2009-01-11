Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbZAKFFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbZAKFFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZAKFFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:05:30 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44095 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZAKFF3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:05:29 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: Re: 2.6.29 -mm merge plans
In-Reply-To: Your message of "Wed, 07 Jan 2009 20:18:34 PST."
             <604427e00901072018o42ff0627yb5282f2a81a13c65@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090105010726.c0433fea.akpm@linux-foundation.org> <6991.1231194895@turing-police.cc.vt.edu>
            <604427e00901072018o42ff0627yb5282f2a81a13c65@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231647500_3490P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Jan 2009 23:18:20 -0500
Message-ID: <3838.1231647500@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231647500_3490P
Content-Type: text/plain; charset=us-ascii

On Wed, 07 Jan 2009 20:18:34 PST, Ying Han said:
> Hi Valdis:
>      Please try this fix and i tested on ubunbu8.10 with xmms and it helps.

Sorry for the long delay in testing, I was offline Wed-Friday taking some
much-needed leave time.

> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9e268b6..f4bbd9b 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c

This didn't apply cleanly to a mmotm-0105 tree, but did apply cleanly
with the following 3 patches reverted and then this new patch applied.

	page_fault-retry-with-nopage_retry.patch
	page_fault-retry-with-nopage_retry-fix.patch
	page_fault-retry-with-nopage_retry-fix-fix.patch

not surprising, since it looks like this patch is a replacement for all 3.  It
built and booted nicely, and xmms on the resulting kernel behaves properly.

Congrats on being able to debug the problem based on my fairly weird bug
report. ;)

--==_Exmh_1231647500_3490P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJaXMMcC3lWbTT17ARAtAPAJ4gLqls56WlOsgdc8TSNqHyDxPMbACgsv5U
NS7HDwgJ/fdb4RN4FrE9a78=
=CZ9i
-----END PGP SIGNATURE-----

--==_Exmh_1231647500_3490P--
