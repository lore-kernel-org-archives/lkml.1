Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbXI1VAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbXI1VAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbXI1VAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:00:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35661 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753806AbXI1VAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:00:20 -0400
Date: Fri, 28 Sep 2007 22:04:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Message-ID: <20070928220446.3f3b839e@the-village.bc.nu>
In-Reply-To: <46FD639D.9030301@rtr.ca>
References: <20070922220347.586903979@linutronix.de>
	<alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
	<46FD639D.9030301@rtr.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And also, I wonder if at a minimum we should be guaranteeing ACPI BIOS calls
> only ever happen from CPU#0 (or the "boot" CPU)?   Or do we do that already?

The real question that matters is "does windows" which possibly someone
who touches Windows can definitively answer. For APM we lock to CPU 0 and
have to because its what MS did, not because of the spec.
