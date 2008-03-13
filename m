Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYCMAkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYCMAkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYCMAkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:40:15 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64327 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYCMAkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:40:14 -0400
Message-Id: <200803130021.m2D0LlFm005300@www262.sakura.ne.jp>
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Mar 2008 09:21:47 +0900
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp> <1205291010.9828.60.camel@nimitz.home.sr71.net> <20080311202212.9fe1e5c1.akpm@linux-foundation.org> <1205313918.8514.215.camel@twins> <20080312165218.GB613@parisc-linux.org>
In-Reply-To: <20080312165218.GB613@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> > Compile tested defconfig with lockdep and !lockdep.
> 
> Thanks for the patch.  I'll merge it into my generic semaphore patch
> and add credit for you if that's OK -- no point in leaving a breakage
> point around for some innocent bisecter to stumble over.

The patch solved "INFO: trying to register non-static key." warning in my environment too. Thank you.

Now, this thread continues with BUG() at mnt_want_write().
