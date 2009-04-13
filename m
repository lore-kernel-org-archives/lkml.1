Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZDMNxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZDMNxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 09:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZDMNx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 09:53:29 -0400
Received: from mga07.intel.com ([143.182.124.22]:50608 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751856AbZDMNx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 09:53:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,180,1239001200"; 
   d="scan'208";a="130848058"
Date: Mon, 13 Apr 2009 21:53:04 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH] readahead: enforce full sync mmap readahead size
Message-ID: <20090413135304.GB10143@localhost>
References: <20090410060957.442203404@intel.com> <20090410061254.719205499@intel.com> <20090410163413.a014bde0.akpm@linux-foundation.org> <20090412070943.GB5737@localhost> <alpine.LFD.2.00.0904120808040.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904120808040.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 08:15:12AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 12 Apr 2009, Wu Fengguang wrote:
> >
> > Now that we do readahead for sequential mmap reads, here is
> > a simple evaluation of the impacts, and one further optimization.
> 
> Hmm.
> 
> Wu, I just went through your latest (?) series of 1-9 and they all looked 
> (a) quite small and (b) all of them looked like good cleanups. 
> 
> And not only do they look good, you seem to have numbers to back it all up 
> too.
> 
> In other words, I'd really prefer to merge this sooner rather than later. 
> There just doesn't seem to be any reason _not_ to. Is there any reason to 
> not just take this? I realize that it's past -rc1, but this is way smaller 
> and saner-looking than the average patch that makes it in past -rc1.
> 
> Besides, it was originally posted before -rc1, and the last series didn't 
> have the much more intrusive page-fault-retry patches. I'd leave those for 
> the next merge window, but the read-ahead series (1-9 plus this final 
> one-liner) seem to be pure improvement - both in code readability _and_ in 
> numbers - with no real contentious issues.
> 
> No?

They shall be fine for 2.6.30. For some reasons I'm submitting them a
bit late, but they are in fact mostly old patches that have received
good pondering and tests in my cookroom :-)

Thanks,
Fengguang
