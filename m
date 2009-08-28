Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZH1TuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZH1TuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZH1TuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:50:02 -0400
Received: from ms.trustica.cz ([82.208.32.68]:53709 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZH1TuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:50:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 15:50:00 EDT
Message-ID: <4A98334B.3040508@assembler.cz>
Date: Fri, 28 Aug 2009 21:43:07 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: mm <mmi@superbash.de>, LKML <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD K10 temp.module ready since months, but missing in kernel...
References: <20090821001322.470bb177@p4laptop> <20090821104533.GA3872@liondog.tnic> <alpine.DEB.2.01.0908261314300.5744@bogon.housecafe.de> <20090827011019.59655f23@phenom> <alpine.DEB.2.01.0908262355340.5744@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0908262355340.5744@bogon.housecafe.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

There is a problem that all chips of fam10h have some errata which renders the
monitoring driver unusable. Some people proposed a workaround if temps look too
suspicious to refuse to load. This is against a sense of monitoring to refuse
the values where they don't look "right". So there is no driver.

There is a patch for fam11h floating around.

Thanks,
Rudolf
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqYM0sACgkQ3J9wPJqZRNWxjQCfdYKzvCu42L7dPlXSHFusAY0T
FMgAnRTxkJrNCFoePwtNLjBTEsCXMF99
=gPv6
-----END PGP SIGNATURE-----
