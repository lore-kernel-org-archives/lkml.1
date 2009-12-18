Return-Path: <linux-kernel-owner+w=401wt.eu-S933091AbZLRVJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbZLRVJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbZLRVJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:09:16 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:46380 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbZLRVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:09:12 -0500
Date: Fri, 18 Dec 2009 12:08:12 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Greg KH <gregkh@suse.de>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [kernel] Re: Fw: Re: [kernel] Re: kernel/rcutree.h:301: sorry,
 unimplemented: inlining failed in call to 'rcu_bootup_announce': function
 body not available
In-Reply-To: <20091218205456.GC6554@suse.de>
Message-ID: <alpine.LNX.2.01.0912181202320.9874@filesrv1.baby-dragons.com>
References: <20091218200839.GF6712@linux.vnet.ibm.com> <20091218205456.GC6554@suse.de>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Fri, 18 Dec 2009 21:08:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello Greg ,

On Fri, 18 Dec 2009, Greg KH wrote:
> On Fri, Dec 18, 2009 at 12:08:39PM -0800, Paul E. McKenney wrote:
>> Hello, Greg,
>>
>> Could you please consider the following commit for 2.6.32-stable?
>> It fixes a build error that some people are seeing.
>>
>> 							Thanx, Paul
>>
>> dbe01350fa8ce0c11948ab7d6be71a4d901be151 rcu: Remove inline from forward-referenced functions
>
> I'm guessing that you don't pay attention to the "now applied to the
> staging..." emails that I send out when I apply patches to different
> trees.  This patch is already queued up for the 2.6.32.2 release which
> will happen in a few hours.
>
> {sigh}
>
> greg k-h
 	Fyi ,  There is another driver that has this issue as well , 
fusion/mptsas ,  has a 'inline' in drivers/message/fusion/mptsas.c at line 
105 that causes compile time failure in the same vein .
 	See email to linux-scsi , Subject: linux-2.6.32.1 drivers/message/fusion/mptsas.c:106: sorry, unimplemented: inlining failed in call to 'mptsas_set_rphy': function body not available
 	I am also having 'ld' time troubles with 
drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to `__udivdi3' and 
have sent emails to the appropriate lists & maintainers(I hope) .

 	Don't know if any of these would/should hold up the push of 32.2 or not 
.
 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
