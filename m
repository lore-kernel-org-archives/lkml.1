Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXIWM1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXIWM1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 08:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXIWM1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 08:27:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43686 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbXIWM1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 08:27:06 -0400
Date: Sun, 23 Sep 2007 13:30:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Verych <olecom@flower.upol.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Message-ID: <20070923133054.61319662@the-village.bc.nu>
In-Reply-To: <200709230824.13320.mihai.dontu@gmail.com>
References: <20070922220347.586903979@linutronix.de>
	<E1IZG8l-0002jB-2k@flower>
	<alpine.LFD.0.999.0709222008580.16478@woody.linux-foundation.org>
	<200709230824.13320.mihai.dontu@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   I switched to libata, but it behaves like the old IDE without ACPI. I
>   did not manage to get a full dmesg (apparently all volumes are mounted
>   r/o right after a power up from a s2ram) but I did make a picture, from
>   which I quote (if I may say so):

Device errors. 

Libata currently (wrongly IMHO) defaults to avoiding the use of ACPI
suspend/resume methods

So you also need to boot with  "libata.noacpi=0" and if that works beat
up Jeff a bit ..

