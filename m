Return-Path: <linux-kernel-owner+w=401wt.eu-S936348AbZAPPf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936348AbZAPPf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbZAPPfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:35:08 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50291 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZAPPfG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:35:06 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
In-Reply-To: Your message of "Thu, 15 Jan 2009 21:59:10 CST."
             <4970060E.3080306@sandeen.net>
From: Valdis.Kletnieks@vt.edu
References: <496EB639.6090800@redhat.com> <20090115162031.a512232b.akpm@linux-foundation.org> <497003CC.8030503@redhat.com>
            <4970060E.3080306@sandeen.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1232120028_11157P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Jan 2009 10:33:48 -0500
Message-ID: <17214.1232120028@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1232120028_11157P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Jan 2009 21:59:10 CST, Eric Sandeen said:

> Oh, actually, I'd think not.  If the freeze was done properly by the
> filesystem, all data was flushed, the fs was quiesced, and new IO was
> blocked.  pdflush should never be visiting these...

Yes, but a lot of 'if's - and usually you're reaching for sysrq-S precisely
*because* you suspect that stuff wasn't happening properly on its own...

--==_Exmh_1232120028_11157P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJcKjccC3lWbTT17ARAh0CAJ0ept2dpXQa3Puc+Ve7iudgHrybswCgsMD+
1f1SDUVzFPl6xm7d9affy8w=
=aZQ7
-----END PGP SIGNATURE-----

--==_Exmh_1232120028_11157P--
