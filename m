Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYJMJQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYJMJQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYJMJQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:16:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:39930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbYJMJQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:16:31 -0400
Message-ID: <48F3113F.7090905@kernel.org>
Date: Mon, 13 Oct 2008 18:13:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <48F00476.6030108@zytor.com>
In-Reply-To: <48F00476.6030108@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Oct 2008 09:15:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tejun Heo wrote:
>>
>> Yeap, if fedora didn't work, I think it should be hidden.  Do we already
>> have place to hide things like this?
>>
> 
> By the way, I don't see anything in this patchset that lets userspace
> discover the parent device.  Since the old rule of
> 
>     partition device = parent device + partition number
> 
> ... no longer holds, this is a serious omission for something that is in
> mainstream (and therefore *requires* that a new interface is deployed
> for anything that cares.)
> 
> This will have to be addressed before 2.6.28 final.

The sysfs directory for the parent can be reached by "cd -P
/sys/class/block/PART/..".  That should be enough, right?  I'll add
the partition attribute but I don't really think we need to do
anything to improve parent discovery.

Thanks.

-- 
tejun
