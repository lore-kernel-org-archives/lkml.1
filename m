Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXCYKaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXCYKaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 06:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXCYKaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 06:30:55 -0400
Received: from www.osadl.org ([213.239.205.134]:47858 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750799AbXCYKay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 06:30:54 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070325102543.GK24225@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174679344.10840.334.camel@localhost.localdomain>
	 <20070325071023.GL17532@mellanox.co.il>
	 <1174808247.10840.467.camel@localhost.localdomain>
	 <20070325085705.GB24225@mellanox.co.il>
	 <1174817872.10840.478.camel@localhost.localdomain>
	 <20070325101548.GI24225@mellanox.co.il>
	 <1174818459.10840.481.camel@localhost.localdomain>
	 <20070325102543.GK24225@mellanox.co.il>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 12:38:23 +0200
Message-Id: <1174819103.10840.484.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 12:25 +0200, Michael S. Tsirkin wrote:
> Sorry, now I'm confused.
> Could you pls list the full set of tests you want me to run,
> and what information to collect from each of them?

1. Test:

add clocksource=acpi_pm to command line with your current kernel config.
Check, whether the resume madness is gone

2. Test

Disable CONFIG_HPET_* in the kernel config and retest

Please capture both logs from boot to resume.

Thanks,

	tglx



