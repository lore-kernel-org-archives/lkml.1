Return-Path: <linux-kernel-owner+w=401wt.eu-S965695AbXAZPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbXAZPzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXAZPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:55:22 -0500
Received: from main.gmane.org ([80.91.229.2]:46981 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965695AbXAZPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:55:20 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Fri, 26 Jan 2007 10:53:43 -0500
Message-ID: <45BA2407.1000003@tmr.com>
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701210005.36274.vda.linux@googlemail.com> <45B3580F.7040407@tls.msk.ru> <200701212102.43028.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@intel.com, akpm@osdl.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <200701212102.43028.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:

> Well, I too currently work with Oracle.
> Apparently people who wrote damn thing have very, eh, Oracle-centric
> world-view. "We want direct writes to the disk. Period." Why? Does it
> makes sense? Are there better ways? - nothing. They think they know better.
> 
I fear you are taking the Windows approach, that the computer is there 
to serve the o/s and applications have to do things the way the o/s 
wants. As opposed to the UNIX way, where you can either be clever or 
stupid, the o/s is there to allow you to use the hardware, not be your 
mother.

Currently applications have the option of letting the o/s make decisions 
  via open/read/write, or let the o/s make decisions and tell the 
application via aio, or using O_DIRECT and having full control over the 
process. And that's exactly as it should be. It's not up to the o/s to 
be mother.

> (And let's not even start on why oracle ignores SIGTERM. Apparently Unix
> rules aren't for them. They're too big to play by rules.)

Any process can ignore SIGTERM, or do a significant amount of cleanup 
before exit()ing. Complex operations need to be completed or unwound. 
Why select Oracle? Other applications may also do that, with more or 
less valid reasons.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

