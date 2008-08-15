Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYHOCQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYHOCQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHOCQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:16:32 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35488 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYHOCQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:16:32 -0400
Cc: Greg KH <greg@kroah.com>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Message-Id: <ECB4FB22-EF4D-4755-AEB8-303E7869EBEC@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <200808150932.44204.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: Core kernel parameters and /sys/parameters?
Date: Fri, 15 Aug 2008 04:16:27 +0200
References: <200807311359.02561.rusty@rustcorp.com.au> <20080814222522.GO30057@kroah.com> <200808150932.44204.rusty@rustcorp.com.au>
X-Mailer: Apple Mail (2.928.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

>>>   Was looking at implementing "core_param" for things like
>>> "initcall_debug" (ie. params with no prefix), and wanted to put  
>>> them in
>>> sysfs of course.  I hacked in a new "kernel" dir, but
>>> /sys/module/kernel/parameters/ is a bit of an odd place for it to  
>>> end up
>>> in.
>>>
>>>   I noticed this comment in params.c:
>>>
>>> * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
>>>
>>> I like the idea of /sys/parameters/ much better (perhaps even with  
>>> core
>>> parameters at the top level).  Is this obsolete?  Planned?
>>
>> Did I write that comment?  I sure don't remember it, sorry :)
>>
>> I don't have any plans on changing this, but I do know people use the
>> /sys/module/MODULE_NAME/parameters interface today, why change it?
>
> Well mainly that many of them aren't modules, so if a change was  
> planned for
> some other reason I'd support it.
>
> And as I said, having core parameters (ie. converting things which  
> are current
> __setup) appear in /sys/module/kernel/parameters/ is a bit strange.

if you guys dislike /sys/module/kernel/* for core stuff, then you  
should do the change as soon as possible since userspace relies on it  
for a lot of tasks. Even I started using it. However I only want one  
general place for kernel/module parameters. A symlink might help us in  
the meantime to get the transition done smoothly.

Regards

Marcel

