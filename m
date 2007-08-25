Return-Path: <linux-kernel-owner+w=401wt.eu-S933422AbXHYI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbXHYI3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbXHYI3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:29:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42076 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761482AbXHYI3l (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:29:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
In-Reply-To: Your message of "Thu, 23 Aug 2007 21:53:53 MDT."
             <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu> <20070823141652.d488a6e0.akpm@linux-foundation.org>
            <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188030574_6255P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 25 Aug 2007 04:29:34 -0400
Message-ID: <6634.1188030574@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188030574_6255P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Aug 2007 21:53:53 MDT, Eric W. Biederman said:
> 
> Grumble.  These numbers should have been in sysctl.h from the
> beginning if we ever expected anyone to use them.  Oh well put
> them there now so we can find them and make maintenance easier.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Applied both patches, and now all I get from irda at boot time now is this:

[  292.062000] irda_init()
[  292.063000] NET: Registered protocol family 23
[  292.069000] IrCOMM protocol (Dag Brattli)
[  292.221000] PPP generic driver version 2.4.2

in other words, business as usual. Thanks.

Feel free to stick this on both patches:

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1188030574_6255P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGz+hucC3lWbTT17ARAhCdAJ49uh3kusRAaoweNEGcKHw2ayrsEwCcCjxZ
uD764mN2nILHZ6Cr3YS+S+E=
=YUbw
-----END PGP SIGNATURE-----

--==_Exmh_1188030574_6255P--
