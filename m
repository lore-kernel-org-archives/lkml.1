Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbZAMXai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbZAMXai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZAMXa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:30:29 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50302 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbZAMXa2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:30:28 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@openedhand.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] backlight: don't default y
In-Reply-To: Your message of "Tue, 13 Jan 2009 15:29:57 +0100."
             <1231856997.3671.38.camel@johannes>
From: Valdis.Kletnieks@vt.edu
References: <1231856997.3671.38.camel@johannes>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231889418_3146P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 18:30:18 -0500
Message-ID: <37023.1231889418@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231889418_3146P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Jan 2009 15:29:57 +0100, Johannes Berg said:
> Not all the backlight drivers make sense, especially not the "generic"
> one that works on some sharp devices. "default n" is also absolutely
> pointless, and not everybody needs LCD backlight support either.

>  config BACKLIGHT_GENERIC
>  	tristate "Generic (aka Sharp Corgi) Backlight Driver"
>  	depends on BACKLIGHT_CLASS_DEVICE
> -	default y
>  	help

I asked about this one recently - apparently it's planned to be much more
generic, but the help text still implies it's Sharp-specific.

--==_Exmh_1231889418_3146P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbSQKcC3lWbTT17ARAgrrAKC+g+j5lAiNzpfUGPuRX1k4OzT/YQCgmpiA
sO0OIu5gMhcntPxp+UIjaUE=
=yg9w
-----END PGP SIGNATURE-----

--==_Exmh_1231889418_3146P--
