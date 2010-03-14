Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0CNSJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:09:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946Ab0CNSJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:09:34 -0400
Date: Sun, 14 Mar 2010 11:07:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
In-Reply-To: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003141105530.3719@i5.linux-foundation.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
 <m1fx43zhbd.fsf@fess.ebiederm.org> <loom.20100314T113306-436@post.gmane.org> <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 14 Mar 2010, Linus Torvalds wrote:
> 
> On Sun, 14 Mar 2010, Wolfram Sang wrote:
>
> > http://patchwork.kernel.org/patch/85212/
> > (which is pretty much the same like the patch originating this thread. I vote
> > very much for dropping those patches and use
> > http://patchwork.kernel.org/patch/84814/ instead!)
> 
> Also, that "firmware_attr_data" thing should probably be marked 'const', 
> no? That should make it more obvious that it's ok to share across multiple 
> different firmware file, I think.

Btw, if it wasn't obvious, this was a comment on that

	http://patchwork.kernel.org/patch/84814/

patch that would replace the one-liner in 85212.

			Linus
