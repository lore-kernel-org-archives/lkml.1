Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYIWOYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYIWOYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYIWOYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:24:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55815 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYIWOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:24:42 -0400
Message-ID: <48D8FC1E.6000601@bull.net>
Date: Tue, 23 Sep 2008 16:24:30 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
In-Reply-To: <20080922153455.GA6238@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Sep 22, 2008 at 04:31:32PM +0200, Benjamin Thery wrote:
>> Hi Greg,
>>
>> Someone made me notice that Eric's "sysfs tagged directories" patchset
>> you merged recently  isn't complete in your "patches" tree. The last two
>> patches that actually uses this new feature aren't in your tree yet.
>>
>> * [PATCH 7/8] netns: Enable tagging for net_class directories in sysfs
>> * [PATCH 8/8] sysfs: user namespaces: fix bug with clone(CLONE_NEWUSER)	
>> with fairsched
>>
>> I didn't noticed it sooner because I'm still using my own version of the
>> patchset on top of linux-2.6.
>>
>> I'm wondering why you left these two patches out? Is it on purpose? Do
>> you expect other maintainers to merged them in their respective tree?
>> Dave Miller acked the patch for network namespace and said "You can send
>> it all through Greg or whoever, don't feel obligated to push it through
>> me since it depends upon the earlier bits in this series".
> 
> I only got so far through the patch set and then got interrupted (was at
> different conferences for 2 weeks), sorry.  I'll get the rest of the
> patchset added later today.
> 
> Note, I did talk to Al Viro about these patches last week at the kernel
> summit, and he advised holding off on sending them to mainline before he
> could review them.  So I'll keep them in my tree for now, but not push
> them to Linus until he acks them as he raised a few issues in our
> conversation.

Oh.
It's a pity Al couldn't re-review them before. We've already lost a lot
of time with this patchset and it's blocking easier testing of network
namespaces (right now, with a mainline kernel, we have to disable sysfs
to build network namespaces).

Eric sent the first version at the end of last year, then I've sent it 6
times between April and July to keep it alive, and finally Eric reworked
the patchset in July and sent a couple of versions to address the issues
Tejun Heo had formulated. It would have been great to receive all the
feedback at that time.

But, I know, we all are busy men and we all have our priorities, and
it takes time to get the things done right and then merged.
I have to learn patience. :)

Thanks anyway. It's a good step to have it in a tree.

Benjamin

> thanks,
> 
> greg k-h
> 
> 


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
