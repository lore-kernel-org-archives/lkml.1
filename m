Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbXDBHWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbXDBHWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXDBHWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:22:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35664 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbXDBHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:22:04 -0400
Date: Mon, 2 Apr 2007 09:22:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] enhance initcall_debug, measure latency
Message-ID: <20070402072202.GC24269@one.firstfloor.org>
References: <20070401181614.GA25648@elte.hu> <20070401182801.GA25956@elte.hu> <p73vegfyzlw.fsf@bingen.suse.de> <20070402070907.GA18480@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402070907.GA18480@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > initcall 0xc1f5487d ran for 23083 msecs: pca_isa_init+0x0/0x143() 
> > > initcall 0xc1f54fba ran for 17121 msecs: pcf8574_init+0x0/0x20()
> > 
> > e.g. those just look like bugs.
> 
> it's ok i think: it's ISA so it spends its time fairly to tickle the 
> ports in a loop.

23 or 17 seconds long?  That's just broken imho.

I presume one could define a background_module_init() for those, 
but it's still buggy.

-Andi
