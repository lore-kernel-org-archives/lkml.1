Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZDLPSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZDLPSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZDLPR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:17:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbZDLPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:17:57 -0400
Date: Sun, 12 Apr 2009 08:15:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH] readahead: enforce full sync mmap readahead size
In-Reply-To: <20090412070943.GB5737@localhost>
Message-ID: <alpine.LFD.2.00.0904120808040.4583@localhost.localdomain>
References: <20090410060957.442203404@intel.com> <20090410061254.719205499@intel.com> <20090410163413.a014bde0.akpm@linux-foundation.org> <20090412070943.GB5737@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Apr 2009, Wu Fengguang wrote:
>
> Now that we do readahead for sequential mmap reads, here is
> a simple evaluation of the impacts, and one further optimization.

Hmm.

Wu, I just went through your latest (?) series of 1-9 and they all looked 
(a) quite small and (b) all of them looked like good cleanups. 

And not only do they look good, you seem to have numbers to back it all up 
too.

In other words, I'd really prefer to merge this sooner rather than later. 
There just doesn't seem to be any reason _not_ to. Is there any reason to 
not just take this? I realize that it's past -rc1, but this is way smaller 
and saner-looking than the average patch that makes it in past -rc1.

Besides, it was originally posted before -rc1, and the last series didn't 
have the much more intrusive page-fault-retry patches. I'd leave those for 
the next merge window, but the read-ahead series (1-9 plus this final 
one-liner) seem to be pure improvement - both in code readability _and_ in 
numbers - with no real contentious issues.

No?

			Linus
