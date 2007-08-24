Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbXHXVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbXHXVWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbXHXVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:22:35 -0400
Received: from ms.trustica.cz ([82.208.32.68]:41486 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXHXVWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:22:34 -0400
Message-ID: <46CF4C0E.3090607@assembler.cz>
Date: Fri, 24 Aug 2007 23:22:22 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Mark Hoffman <mhoffman@lightlink.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon coretemp: Remove bogus __cpuinitdata etc cleanup
References: <alpine.LFD.0.999.0708230910120.2049@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708230910120.2049@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

> The CPU hotplug notifier_block coretemp_cpu_notifier is already defined
> inside an #ifdef HOTPLUG_CPU, therefore marking it as __cpuinitdata is
> quite a pointless thing to do.

Yep true.

> Also, remove duplicate prototype of function coretemp_update_device()

Good catch. Thanks for the fixes.

Acked-by: Rudolf Marek <r.marek@assembler.cz>

Rudolf
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGz0wO3J9wPJqZRNURAnerAKDiDMzqqvymSbvVuVzuvA+dkF8p8gCdGyq7
spqOnJ6YD8NxNgTNSBW8okY=
=/u3Y
-----END PGP SIGNATURE-----
