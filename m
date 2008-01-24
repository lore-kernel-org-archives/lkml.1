Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYAXJPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYAXJPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAXJPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:15:00 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58569 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYAXJO7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:14:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: Your message of "Wed, 23 Jan 2008 18:38:53 PST."
             <1201142334.6383.40.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1201142334.6383.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201166073_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 04:14:33 -0500
Message-ID: <5557.1201166073@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201166073_2846P
Content-Type: text/plain; charset=us-ascii

On Wed, 23 Jan 2008 18:38:53 PST, john stultz said:
> I recently noticed on one of my boxes that when synched with an NTP
> server, the drift value reported for the system was ~283ppm. While in
> some cases, clock hardware can be that bad, it struck me as unusual as
> the system was using the acpi_pm clocksource, which is one of the more
> trustworthy and accurate clocksources on x86 hardware.
> 
> I brought up another system and let it sync to the same NTP server, and
> I noticed a similar 280some ppm drift.

So I got curious, and dropped the patch onto my workstation - 24-rc8-mm1 x86_64
and it applied just fine with an offset reported.

Before the patch, the drift was reported as 140.67 or so.
After, it's sitting at -0.681.

Am running with hpet clocksource rather than acpi_pm, which probably explains
the 140 I see rather than the 280 John saw....

--==_Exmh_1201166073_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmFb5cC3lWbTT17ARAuz7AJwOjhiDXmHphwHRedrFovaE8gYvYQCfXIWQ
xrPMcKlnArwW7BirZY1kkYk=
=bvhz
-----END PGP SIGNATURE-----

--==_Exmh_1201166073_2846P--
