Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbXITUQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbXITUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXITUQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:16:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbXITUQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:16:49 -0400
Date: Thu, 20 Sep 2007 13:15:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       Neil Brown <neilb@suse.de>, Trond Myklebust <trond@netapp.com>,
       stable@kernel.org
Subject: Re: [PATCH] rpc: fix garbage in printk in svc_tcp_accept()
In-Reply-To: <20070920195146.GC23287@fieldses.org>
Message-ID: <alpine.LFD.0.999.0709201310230.16478@woody.linux-foundation.org>
References: <20070920195146.GC23287@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, J. Bruce Fields wrote:
>
> we upgraded the kernel of a nfs-server from 2.6.17.11 to 2.6.22.6. Since
> then we get the message
...

Bruce - you're losing authorship information.

Please don't do that.

Put a 

	From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>

at the top of the email, so that the author gets properly attributed. I 
don't know how many of these I've missed - in this case I just ended up 
googling for the commit message because the "Signed-off-by:" lines implied 
that you weren't the original author, and see the real patch authorship 
that way.

But it's *not* the case that the first sign-off is always the author, and 
I don't want to need to google for each patch I get, so please make it a 
habit to make sure that there's proper attribution for the patches.

Some people (read: Andrew) go so far as to *always* do it (ie Andrew puts 
a "From: Andrew Morton .." at the heads of the emails he sends out), and I 
appreciate it. That way, even if the email then gets forwarded by somebody 
else (because Andrew sent it to some submaintainer instead of me), the 
original authorship doesn't get lost when somebody else then forwards the 
email.

So that "always explicitly say who the author is" is a good idea, but when 
forwarding somebody elses patch, it's *more* than a good idea - at that 
point it's absolutely required for proper attribution.

		Linus
