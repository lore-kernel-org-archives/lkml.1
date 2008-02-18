Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYBRFGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYBRFGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYBRFGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:06:42 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58080 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYBRFGl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:06:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/hdsmart.h: fix goofups
In-Reply-To: Your message of "Sun, 17 Feb 2008 12:17:20 EST."
             <alpine.LFD.1.00.0802171214380.3515@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <200802171807.57983.bzolnier@gmail.com>
            <alpine.LFD.1.00.0802171214380.3515@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203311197_6672P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 00:06:37 -0500
Message-ID: <30744.1203311197@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203311197_6672P
Content-Type: text/plain; charset=us-ascii

On Sun, 17 Feb 2008 12:17:20 EST, "Robert P. J. Day" said:

> if that header file isn't used by any kernel code, why bother having a
> check for __KERNEL__ in the first place?  it's being exported to
> userspace unchecked:
> 
>   include/linux/Kbuild:header-y += hdsmart.h
> 
> so why not just toss that check entirely?  otherwise, you're going to
> get a header file exported to userspace that has a superfluous
> __KERNEL__ test in it.

Umm... if the kernel isn't using it, why are we bothering to export it to
userspace at all?  Or is the kernel using something *else* that should be going
to userspace instead?

--==_Exmh_1203311197_6672P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHuRJdcC3lWbTT17ARAty2AJ9fUXxnYDuXFIss6Sm+uT2wl5mzGwCgnukD
E8T1m7WHZCH/TzyiJQOBcFU=
=3MUy
-----END PGP SIGNATURE-----

--==_Exmh_1203311197_6672P--
