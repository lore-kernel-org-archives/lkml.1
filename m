Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZJ2BLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZJ2BLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZJ2BLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:11:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36912 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZJ2BLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:11:51 -0400
Message-ID: <4AE8EBCB.5030102@canonical.com>
Date: Thu, 29 Oct 2009 09:11:39 +0800
From: Bryan Wu <bryan.wu@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Brian Swetland <swetland@google.com>, Eric Miao <eric.miao@canonical.com>,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com> <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com> <20091027140558.GA17208@suse.de> <4AE8E953.6090504@canonical.com> <20091029010419.GA18410@suse.de>
In-Reply-To: <20091029010419.GA18410@suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Oct 29, 2009 at 09:01:07AM +0800, Bryan Wu wrote:
>> Greg KH wrote:
>>> On Tue, Oct 27, 2009 at 12:40:07PM +0800, Eric Miao wrote:
>>>>> Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
>>>>>    headers: remove sched.h from poll.h
>>>>>
>>>>> Adding <linux/sched.h> to fix this compiling bug.
>>> I have now just marked the android drivers as broken, as this is not the
>>> only build error in them at the moment :(
>>>
>> Yeah, actually the drivers/staging/android/lowmemorykiller.c has been
>> failing to compile for a long time, because that struct mm_struct does
>> not have a field named oom_adj. All the Android drivers are compiled
>> as modules in Ubuntu kernel package, except this one.
>>
>> Although Android public kernel is still in 2.6.29, it's own driver is
>> totally different with our mainline staging version. Is there any plan
>> to sync with it?
> 
> No, Google has abandoned any current effort to push code upstream for
> the past year :(
> 
> The android drivers are deleted in linux-next and will go away in 2.6.33
> because of this.
> 

Thanks a lot for this update. It looks like we need to consider to drop Android 
modules in our Ubuntu kernel building somehow.

Cheers,
-Bryan
