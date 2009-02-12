Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZBLDiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZBLDiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZBLDiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:38:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:58314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZBLDiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:38:04 -0500
Message-ID: <49939964.4070607@kernel.org>
Date: Thu, 12 Feb 2009 12:37:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <4983E5D3.3040100@kernel.org> <200902021934.14168.rusty@rustcorp.com.au> <498908F9.9040901@kernel.org>
In-Reply-To: <498908F9.9040901@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Feb 2009 03:37:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tejun Heo wrote:
> Rusty Russell wrote:
>> On Saturday 31 January 2009 16:16:59 Tejun Heo wrote:
>>> Anyways, please pull from
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
>> Thanks.  cpualloc patches rebased on top of it (I had to include the module
>> patch I've got queued for 2.6.29, otherwise gratuitous conflicts):
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/tj-percpu-cpualloc master
>>
>> Boot tested here, but that's no guarantee that something didn't break.
>>
>> I'm going to be occupied with finishing off cpumask_t this cycle, so I'd be
>> happy for you to take ownership of any and all of these that you want to keep.
>> I'll try to keep up with other patches as you post them.
> 
> Will merge it in this week.

Okay, just went through the patchset.  It generally looks nice and
clean but I'm still a bit hung up on the idea of making percpu area
resizable.  I'll look into Christoph Lameter's cpu_alloc patchset too
and think about it more.

Thanks.

-- 
tejun
