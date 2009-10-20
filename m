Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZJTWv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZJTWv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZJTWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 18:51:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59087 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZJTWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 18:51:26 -0400
Message-ID: <4ADE3EE9.3090308@us.ibm.com>
Date: Tue, 20 Oct 2009 15:51:21 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] futex: Detect mismatched requeue targets
References: <1953271756.544571256071596329.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1953271756.544571256071596329.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur wrote:
> ----- "Darren Hart" <dvhltc@us.ibm.com> wrote:
> 
>> John Kacur wrote:
>>> Hello Darren
>>>
>>> I took your patch from commit
>> 84bc4af59081ee974dd80210e694ab59ebe51ce8
>>> and I tried to git-cherry-pick it for v2.6.31.4-rt14
>>>
>>> I had a little merge-commit to resolve. That wasn't too hard, but as
>> the 
>>> code is a bit different between the two versions, I would appreciate
>> it if 
>>> you could review the patch, and make sure that it still makes sense
>> for 
>>> v2.6.31.r-rt14
>> Hi John,
>>
>> It looks good to me.  Where did you have the conflicts?
>>
>> --
> 
> The conflict was in the futex_wait_requeue_pi function.
> That's where you really need to double check that the logic still makes sense.

Hi John,

Yes, I suspect the conflict was do to the retry: label. You should have 
already pulled in the spurious wakeup patch, so you should be fine.  The 
patch looks good to me.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
