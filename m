Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbXDURYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbXDURYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXDURYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 13:24:20 -0400
Received: from nile.gnat.com ([205.232.38.5]:42180 "EHLO nile.gnat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbXDURYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 13:24:19 -0400
X-Greylist: delayed 1273 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2007 13:24:19 EDT
In-Reply-To: <20070421161818.GC7840@1wt.eu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7DBADB75-A300-4999-9DBF-09743D5301C8@adacore.com>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Content-Transfer-Encoding: 7bit
From: Geert Bosch <bosch@adacore.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sat, 21 Apr 2007 13:03:04 -0400
To: Willy Tarreau <w@1wt.eu>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 21, 2007, at 12:18, Willy Tarreau wrote:
> Also, I believe that (in shells), most forked processes do not even  
> consume
> a full timeslice (eg: $(uname -n) is very fast). This means that  
> assigning
> them with a shorter one will not hurt them while preserving the  
> shell's
> performance against CPU hogs.

On a fast machine, during regression testing of GCC, I've noticed we  
create
an average of 500 processes per second during an hour or so. There  
are other
work loads like this. So, most processes start, execute and complete  
in 2ms.
How does fairness work in a situation like this?

   -Geert
