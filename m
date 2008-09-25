Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYIYT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYIYT2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIYT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:28:01 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:58938 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYIYT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mfqHA8yLH/6t5w1lMk9R2YljTupmbd815LfO8Hx0g0m7on2RfLZmzBe7JE/yeE9B7V
         3DB0po8OaYCyAMFzjjeMJ1F5vqSUUeRbLiWudPrZ3Xw8eJMnbsYZRnt3Do/1PZgRqwNL
         hTGgTM09lztIhE2c1rMerWmXhxPQatD9ZcYmY=
Date: Thu, 25 Sep 2008 23:27:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tej <bewith.tej@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel PANIC with 2.6.27-rc6
Message-ID: <20080925192755.GE7259@localhost>
References: <f1c9d250809110841s5c3d08b9ha93f0ef1da58642a@mail.gmail.com> <48C94F65.3050405@windriver.com> <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com> <20080925145635.GA7277@localhost> <20080925154724.GB7277@localhost> <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tej - Fri, Sep 26, 2008 at 12:04:30AM +0530]
...
| >
| > If assume that git bisect is right - it's hardly possible
| 
| i have bisected it twice n jason mentioned that it looks like some
| kind of nmi race condition.
| 
| but i will bisect it again in rc7 and let you know.
| 
| > that proc_nmi_enabled() related changes introduced this
| > error (ie this commit) - kgdb seems to be not
| > touching /proc/sys/kernel/nmi while doing self-tests.
| >
| > 		- Cyrill -
| >
| 

There was a race in nmi code indeed which was fixed recently in
-tip tree but it was leading to use unitialized vars. So give
me some time to digg a bit. I'll do it tomorrow and write you.
Thanks a lot for pointing out this problem!

		- Cyrill -
