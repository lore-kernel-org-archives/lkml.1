Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXI1Rc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXI1Rc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbXI1RcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:32:19 -0400
Received: from mga05.intel.com ([192.55.52.89]:50522 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751201AbXI1RcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:32:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="327926898"
Date: Fri, 28 Sep 2007 10:31:55 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-ID: <20070928173155.GD3219@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <46FC2245.50907@tiscali.nl> <1190967450.18681.10.camel@chaos> <20070928012656.0bae3991.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928012656.0bae3991.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 01:26:56AM -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > can we please add this to checkpatch.pl ? 
> > 
> > > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > > +DEFINE_SPINLOCK(bpci_lock);
> 
> That check is already in checkpatch.  Problem is that hardly anyone
> runs the thing.
> 
> I think we're ready to wire checkpatch up to a email robot which monitors
> the mailing lists and sends people nastygrams.  I bet that'll be popular ;)

One could make check patch create a signature hashing a check patch key
and the patch one could put in the post like a signed-off-by: thing.

checkpatch-sig : 2f818bcf0c2333a461affc4a170814f23adf2e08

this puts the burden on the sender to run the thing.

--mgross
