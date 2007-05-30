Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbXE3DbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbXE3DbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 23:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXE3Daw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 23:30:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54971 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339AbXE3Dau (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 23:30:50 -0400
Date: Wed, 30 May 2007 13:30:41 +1000
From: David Chinner <dgc@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at kernel/fork.c:385
Message-ID: <20070530033041.GH86004887@sgi.com>
References: <20070522234314.54081817.akpm@linux-foundation.org> <617E1C2C70743745A92448908E030B2A01882BFD@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A01882BFD@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 10:44:16AM -0700, Luck, Tony wrote:
> > > Saw this when running strace -f on a script on 2.6.21 on ia64:
> > > 
> > > BUG: sleeping function called from invalid context at kernel/fork.c:385
> > > in_atomic():1, irqs_disabled():0
>     ... snip ...
> > > I could reproduce it via 'strace -f sleep 1'
> > > 
> >
> > I'd say this is specific to ia64.   Someone would have spotted it on
> > x86 by now.
> 
> I tried the "strace -f sleep 1" on 2.6.22-rc2, and I didn't see this "BUG"
> there.  Can you try your other test cases on the latest kernel.  If it has
> already been fixed we can see about identifying the patch for possible backport
> to 2.6.21.stable

Sorry for taking so long to get back to this - I still see this in
2.6.22-rc2.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
