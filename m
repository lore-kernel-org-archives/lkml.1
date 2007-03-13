Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbXCMCcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbXCMCcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 22:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbXCMCcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 22:32:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40582
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbXCMCcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 22:32:12 -0400
Date: Mon, 12 Mar 2007 19:32:11 -0700 (PDT)
Message-Id: <20070312.193211.30184040.davem@davemloft.net>
To: paulus@samba.org
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.com, holt@sgi.com,
       linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070312.192616.63128242.davem@davemloft.net>
References: <20070312.155157.74747634.davem@davemloft.net>
	<17909.62028.117035.287313@cargo.ozlabs.ibm.com>
	<20070312.192616.63128242.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 12 Mar 2007 19:26:16 -0700 (PDT)

> From: Paul Mackerras <paulus@samba.org>
> Date: Tue, 13 Mar 2007 11:37:32 +1100
> 
> > David Miller writes:
> > 
> > > I ported this to sparc64 as per the patch below, tested on
> > > UP SunBlade1500 and 24 cpu Niagara T1000.
> > 
> > Did you see any performance improvement?  We used to have quicklists
> > on ppc, but I remain to be convinced that they actually help.
> 
> It shaved about 3 or 4 seconds consistently off of my kernel
> build on Niagara which usually clocks in just over 4 minutes
> on this 24 thread machine.

I want to quantify this with the fact that all the cache false sharing
issues are irrelevant in this test because the L2 cache is shared
between all of the cpu threads on Niagara.

It was fast just because the quicklists were lighter weight than the
SLAB stuff.
