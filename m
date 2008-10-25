Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYJYM0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYJYM0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 08:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYJYM0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 08:26:02 -0400
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1071 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751346AbYJYM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 08:26:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 2961
Date: Sat, 25 Oct 2008 14:25:42 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Re: ext3: fix ext3_dx_readdir hash collision handling
	-  Regression
Message-ID: <20081025122542.GA2354@gentoox2.trippelsdorf.de>
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de> <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org> <20081025115631.GA17661@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025115631.GA17661@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 07:56:31AM -0400, Theodore Tso wrote:
> 
> Unfortunately, the commit which which fixes the duplicated entries
> when there are hash collisions wasn't properly setting info->curr_hash
> and info->curr_minor_hash after going to the next node, which results
> the first entry being returned twice on the subsequent getdents()
> system call.  What I don't understand was why I wasn't seeing this on
> a 32-bit kernel (maybe I screwed up my test environment; this problem
> should have occurred regardless of the 32-bit or 64-bit environment).
> 
> In any case, if folks could test to see whether this patch fixes
> things, I'd appreciate it.  (Patch for ext3 and ext4 follows).
> 
> 							- Ted

Yep, your patch fixes the issue. Thank you Ted.

-- 
Markus
