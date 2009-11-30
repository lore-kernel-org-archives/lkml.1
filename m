Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZK3Jpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZK3Jpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZK3Jpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:45:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZK3Jpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:45:54 -0500
Message-ID: <4B13942E.3000002@redhat.com>
Date: Mon, 30 Nov 2009 11:45:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving sched_in_preempt_notifers
References: <4AFD2801.7020900@kernel.org> <20091113095516.GD1364@elte.hu> <4AFEAB6D.60600@redhat.com> <4B138BC8.3090008@kernel.org>
In-Reply-To: <4B138BC8.3090008@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 11:09 AM, Tejun Heo wrote:
>
>>
>>>    but we want to do sched.c changes via
>>> the scheduler tree.
>>>        
> So, this one was a bust.  Given that the only platform which might
> have been affected by the original bug is ia64 and it's very unlikely
> to happen.  I think reverting this from sched/urgent would be the
> right thing to do at this point if the branch is headed for another
> push to Linus.  Avi, what do you think?
>    

I agree.

-- 
error compiling committee.c: too many arguments to function

