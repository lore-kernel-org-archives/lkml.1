Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbXCWSXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbXCWSXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXCWSXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:23:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXCWSXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:23:51 -0400
Date: Fri, 23 Mar 2007 11:16:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
In-Reply-To: <Pine.LNX.4.64.0703231112350.6730@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703231115090.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <20070318184908.GU752@stusta.de>  <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
  <46020385.50301@yahoo.com.au>  <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
  <1174612132.16068.114.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> 
 <20070323114223.GA23483@elte.hu> <1174650969.10840.274.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703231112350.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Mar 2007, Linus Torvalds wrote:
> 
> I really wish we had an x86-64 maintainer that understood that it's 
> confusing that files in arch/i386/ are also used for arch/x86-64.

Sorry, that was unfair. The patch was simply buggy. It added the test to 
drivers/acpi/ *without* adding it to the architectures that used it, it 
wasn't an i386/x86-64 thing.

Thomas, please fix.

		Linus
