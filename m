Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYIZOv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYIZOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYIZOvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:51:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37939 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYIZOvu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:51:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rafal <newsgroup@limcore.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel unable to adjust timeofday
In-Reply-To: Your message of "Fri, 26 Sep 2008 15:29:53 +0200."
             <gbio4j$aqq$1@ger.gmane.org>
From: Valdis.Kletnieks@vt.edu
References: <gbio4j$aqq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222440706_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2008 10:51:46 -0400
Message-ID: <47571.1222440706@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1222440706_7097P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2008 15:29:53 +0200, Rafal said:
> Hello, my system (64bit Ubuntu amd64 box) drifts about 10 seconds per hour
> (i.e. time visible in the system).

First thing to do is figure out why your box has *such* a dreadfully poor
clock. You're drifting at around 3,000 parts-per-million.  NTP is only able
to deal with drifts up to 500 ppm, and most systems clocks are *much* more
stable than that (for instance, my laptop is drifting at 2 ppm at the moment).
The fact you're way outside the sane range leads to trouble...

> When I use adjtime(), or when I use ntpd that uses adjtime() then the
> adjustment is slower then the speed of drift.

... which is why you see this happen.

> The default rate of adjustment seems to be really low, can we set the
> default adjustment rate to be a higher?

The default rate is set fine.  It's simply unable to deal with insane hardware
and/or software.  What kernel are you running on it?

--==_Exmh_1222440706_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3PcCcC3lWbTT17ARAhsVAJ9Wqn1zgfam794rRAKSc4XIXy4S4wCgx9d+
n4FstdWIcxxKwIHt0byW4Qs=
=w9lb
-----END PGP SIGNATURE-----

--==_Exmh_1222440706_7097P--
