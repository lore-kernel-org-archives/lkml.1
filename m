Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYA2WC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYA2WC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYA2WCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:02:47 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:24477 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYA2WCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:02:46 -0500
Date: Tue, 29 Jan 2008 14:02:35 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mike.miller@hp.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com
Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with recent
	linux-2.6  tree)
Message-ID: <20080129220235.GE21785@plap3.qlogic.org>
References: <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk> <20080129210837.GA21785@plap3.qlogic.org> <20080129211634.GB15220@kernel.dk> <20080129212435.GC15220@kernel.dk> <1FE6DD409037234FAB833C420AA843EC757564@orsmsx424.amr.corp.intel.com> <20080129213526.GE15220@kernel.dk> <1FE6DD409037234FAB833C420AA843EC7575C5@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC7575C5@orsmsx424.amr.corp.intel.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Jan 2008 22:02:45.0319 (UTC) FILETIME=[AD725D70:01C862C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Luck, Tony wrote:

> > > Will try this next.
> >
> > Should work even better since it avoids a lock and copy, but please do
> > test if you have the time.
> 
> That one works too (survived two full builds at "make -j32" on the 16-way
> system).
> 
> Thanks for the quick turnaround.

Jens, this patch appears to work well on my 16-way box...  Compile
tests appear to pass (quickly).  I'll be sure to let you know if
anything else 'block' related pops-up...

thanks, av
