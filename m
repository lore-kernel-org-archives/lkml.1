Return-Path: <linux-kernel-owner+w=401wt.eu-S935886AbXGZT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935886AbXGZT7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXGZT7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:59:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933104AbXGZT7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:59:22 -0400
Date: Thu, 26 Jul 2007 12:59:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC nx6325
 (x86_64)
In-Reply-To: <200707262122.50517.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.999.0707261258030.3442@woody.linux-foundation.org>
References: <200707261440.50649.rjw@sisk.pl>
 <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
 <200707262122.50517.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Rafael J. Wysocki wrote:
> > 
> > Rafael, does reverting just this part (and leaving the "text_poke()" 
> > cleanups) work for you?
> 
> Yes, it does, with the appended fix on top. :-)

Heh, I noticed that myself, but assumed you'd figure it out. 

I ended up renaming "oaddr" as "addr", so the thing I committed is 
slightly different from the patch (+ your fix), but it should be otherwise 
100% equivalent.

		Linus
