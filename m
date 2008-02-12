Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYBLWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYBLWs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYBLWsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:48:18 -0500
Received: from mga07.intel.com ([143.182.124.22]:30933 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbYBLWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:48:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,342,1199692800"; 
   d="scan'208";a="378258714"
Message-ID: <47B22202.4070702@linux.intel.com>
Date: Tue, 12 Feb 2008 14:47:30 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Subject: Re: [GIT PULL?] Create and populate toplevel tests/ for kernel tests
References: <20080211104452.GB7944@in.ibm.com> <20080212164452.GA31096@infradead.org> <20080212132246.aac67ed1.akpm@linux-foundation.org> <20080212223918.GA3927@uranus.ravnborg.org>
In-Reply-To: <20080212223918.GA3927@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Hi Linus.
> 
> Will you consider such a primary code-movement for -rc1
> or shall we wait until next merge window?
> 
> Had we hit -rc2 I would not have sent this pull req and
> feel free to flame me anyway.
> 
> The rationale to get it merged is obviously to avoid
> merge conflicts and the only reason I ask is that I consider
> it a low risk patch.
> 
> I have not included 8/8 since it was questioned and it
> will wait until next merge window. But the first 7 was
> straightforward.
> 
> You can pull from:
> ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/tests.git
> 
> diffstat and shortlog below.
> I also included mail last with a few of the merge related comments.
> 
> 	Sam
> 
>  Makefile                                        |    1 +
>  drivers/misc/Makefile                           |    1 -
>  kernel/Makefile                                 |    4 -
>  lib/Kconfig.debug                               |   71 +--------------------
>  lib/Makefile                                    |    1 -
>  tests/Kconfig                                   |   79 +++++++++++++++++++++++



we could make it even lower risk and not move the Kconfig now.
Moving the Kconfig is fine for .26; it doesn't really impact anything else
