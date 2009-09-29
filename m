Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZI2LMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZI2LMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZI2LMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:12:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52712 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZI2LMl (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Tue, 29 Sep 2009 07:12:41 -0400
Message-ID: <4AC1EBEE.8040303@suse.de>
Date: Tue, 29 Sep 2009 16:43:50 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
References: <4AC1A6FB.1080304@suse.de> <20090928232748.c41eeb5b.akpm@linux-foundation.org>
In-Reply-To: <20090928232748.c41eeb5b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 29 Sep 2009 11:49:39 +0530 Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> Hi all,
>>
>> On Thu, Sep 10, 2009 at 11:31 AM,  <akpm@linux-foundation.org> wrote:
>>> The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
>>>
>>>   http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>   git://git.zen-sources.org/zen/mmotm.git
>>>
>> With this snapshot plus fixes, I'm unable to limit the memory using the
>> kernel command line switch "mem=nn" on a x86_64 box. Is this the
>> expected behavior?
>>
>> Using "cgroup_disable=memory" together with "mem=nn" switch didn't help.
>> Am I supposed to use some other switch along with this?
>>
> 
> hm, perhaps that -mm was needing this?
> 

Yes, it does. /me yet to catch up with the latest -mm.

> commit eda6da9286ad5b35b1eb70f6368958a8ee41a9dd
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Sat Sep 19 11:07:57 2009 -0700
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat Sep 19 20:31:33 2009 +0200
> 

After applying this patch "mem=nn" works.

Thanks,

-- 
Suresh Jayaraman
