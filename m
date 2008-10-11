Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbYJKAww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbYJKAww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 20:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYJKAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 20:52:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbYJKAwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 20:52:42 -0400
Message-ID: <48EFF84B.5060108@kernel.org>
Date: Sat, 11 Oct 2008 09:50:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Oct 2008 00:52:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus Torvalds wrote:
> On Fri, 10 Oct 2008, Ingo Molnar wrote:
>> | 870d6656126add8e383645732b03df2b7ccd4f94 is first bad commit
>> | commit 870d6656126add8e383645732b03df2b7ccd4f94
>> | Author: Tejun Heo <tj@kernel.org>
>> | Date:   Mon Aug 25 19:47:25 2008 +0900
>> |
>> |     block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT
>>
>> and meanwhile 2 other test-systems failed to boot as well - both have 
>> CONFIG_DEBUG_BLOCK_EXT_DEVT=y.
>>
>> So i guess this debug feature is working as expected.
> 
> Ahh, yeah, sounds that way.
> 
>> I guess we should mark CONFIG_DEBUG_BLOCK_EXT_DEVT=y as really dangerous 
>> to enable because contemporary distributions (i tried Fedora 9) fail 
>> with it too?
> 
> Tejun - do you know whether _any_ distro will boot with 
> CONFIG_DEBUG_BLOCK_EXT_DEVT=y?

Hmmm... openSUSE 11.0 didn't have any problem with it, which I was a bit
pleasantly surprised about.  I haven't tested management tools but the
base system worked just fine.

> It does sound like perhaps the option should be hidden more, if it's 
> really only reasonably enabled for some very specialized distro debuggers, 
> not normal kernel people.

Yeap, if fedora didn't work, I think it should be hidden.  Do we already
have place to hide things like this?

Thanks.

-- 
tejun
