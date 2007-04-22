Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXDVFA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXDVFA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 01:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXDVFA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 01:00:56 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:46328 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXDVFAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 01:00:55 -0400
Message-ID: <462AEBFE.80500@linux.vnet.ibm.com>
Date: Sun, 22 Apr 2007 10:30:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@in.ibm.com>, nagar@watson.ibm.com, jlan@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Taskstats fix the structure members alignment issue
References: <20070420164341.14718.5013.sendpatchset@balbir-laptop> <20070420121543.6a1a8426.akpm@linux-foundation.org> <462A0AA9.8000304@linux.vnet.ibm.com> <20070421123307.5dc2566f.akpm@linux-foundation.org>
In-Reply-To: <20070421123307.5dc2566f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Apr 2007 18:29:21 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>>> The patch adds an __attribute__((aligned(8))) to the
>>>> taskstats structure members so that 32 bit applications using taskstats
>>>> can work with a 64 bit kernel.
>>> But there might be 32-bit applications out there which are using the
>>> present wrong structure?
>>>
>>> otoh, I assume that those applications would be using taskstats.h and would
>>> hence encounter this bug and we would have heard about it, is that correct?
>>>
>> Yes, correct.
>>
>>> otoh^2, 32-bit applications running under 32-bit kernels will presently be
>>> functioning correctly, and your change will require that those applications
>>> be recompiled, I think?
>>>
>> Yes, correct. They would be broken with this fix. We could  bump up the
>> version TASKSTATS_VERSION to 4. Would you like a new patch the version
>> bumped up?
> 
> I can do that.

Thanks

> 
>>> This patch looks like 2.6.20 and 2.6.21 material, but very carefully...
>> Yes, 2.6.20 and 2.6.21 sound correct.
> 
> OK.  I guess we have little choice but to slam it in asap, with a 2.6.20.x backport
> before too many people start using the old interface.

Thanks, again!

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
