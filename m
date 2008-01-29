Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYA2Vfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYA2Vfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYA2Vfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:35:31 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29674 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYA2Vfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:35:31 -0500
Date: Tue, 29 Jan 2008 22:35:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mike.miller@hp.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com
Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Message-ID: <20080129213526.GE15220@kernel.dk>
References: <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk> <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk> <20080129210837.GA21785@plap3.qlogic.org> <20080129211634.GB15220@kernel.dk> <20080129212435.GC15220@kernel.dk> <1FE6DD409037234FAB833C420AA843EC757564@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC757564@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Luck, Tony wrote:
> >> Ah crap, I see the problem, nioc is most often equal to rioc. Dang.
> >> Please try this bandaid, will push a real fix now.
> 
> Patches arriving faster than I can test :-) ... The bandaid appears to
> be working (no hang yet).

OK good!

> > This is way cleaner.
> 
> Will try this next.

Should work even better since it avoids a lock and copy, but please do
test if you have the time.

-- 
Jens Axboe

