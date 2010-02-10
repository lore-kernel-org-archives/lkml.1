Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0BJKdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:33:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:36437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0BJKdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:33:00 -0500
Message-ID: <4B728CFE.40208@kernel.org>
Date: Wed, 10 Feb 2010 19:39:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
In-Reply-To: <m1vde57c11.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 10:32:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 05:03 PM, Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Hello,
>>
>> On 02/10/2010 11:08 AM, Américo Wang wrote:
>>> This bug report is new for me. Recently we received lots of sysfs lockdep
>>> warnings, I am working on a patch to fix all the bogus ones.
>>>
>>> However, this one is _not_ similar to the other cases, as you decribed.
>>> This patch could fix the problem, but not a good fix, IMO. We need more
>>> work in sysfs layer to fix this kind of things. I will take care of this.
>>
>> Can't we just give each s_active lock a separate class?  Would that be
>> too costly?
> 
> When I asked the question earlier I was told that that locking classes
> require static storage.  Where would that static storage come from?

Maybe I'm glossly misunderstanding it but wouldn't embedding struct
lockdep_map into sysfs_node as in work_struct do the trick?

Thanks.

-- 
tejun
