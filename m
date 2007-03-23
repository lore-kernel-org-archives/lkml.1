Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXCWSgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXCWSgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXCWSgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:36:36 -0400
Received: from www.osadl.org ([213.239.205.134]:34765 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753292AbXCWSgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:36:35 -0400
Subject: Re: [1/6] 2.6.21-rc4: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <Pine.LNX.4.64.0703231124370.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184908.GU752@stusta.de>
	 <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
	 <46020385.50301@yahoo.com.au>
	 <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323114223.GA23483@elte.hu>
	 <1174650969.10840.274.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703231112350.6730@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703231115090.6730@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703231124370.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 19:43:57 +0100
Message-Id: <1174675437.10840.315.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 11:28 -0700, Linus Torvalds wrote:
> 
> On Fri, 23 Mar 2007, Linus Torvalds wrote:
> > 
> > Thomas, please fix.
> 
> Here's a possible fix. It compiles. And I still wish we had common files.

You beat me by 30 seconds.

> ia64 shouldn't be affected, because ia64 doesn't #define the 
> ARCH_APICTIMER_STOPS_ON_C3 flag (and then we don't use the "c2_ok" thing 
> either. 

Right, ia64 does not see it.

> But this is still pretty damn ugly.

Yes it is.

> Maybe a field in "struct acpi_processor" for C2/C3 problems?

Hmm, the acpi processor stuff is modular.

	tglx


