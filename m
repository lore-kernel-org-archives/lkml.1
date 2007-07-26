Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXGZMBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXGZMBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXGZMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:01:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:29940 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXGZMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zat1YZ7zoxv2Q4pOQ4AWgr7lbHPl3K/L1Ki8SDo9bZFNi86QKjkoaJ20njOmJKwLxDlDvDhCZEBKm3sb5ykYgvSLtTvbLXCVbLhD0By6T8gHG9zHVpvo70tc5xKgmz6crsrtF4GN93FM1cR4B4Fq+e2Wo5U7neJxCLCPRcQsvvs=
Date: Thu, 26 Jul 2007 20:03:34 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][resend] sysfs/file.c - use mutex instead of semaphore
Message-ID: <20070726120334.GA2404@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070726110354.GA3672@darkstar.te-china.tietoenator.com> <20070726054600.GA25263@suse.de> <a8e1da0707252346r471c66f5ycac75a0ec69b5b94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0707252346r471c66f5ycac75a0ec69b5b94@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 06:46:26AM +0000, Dave Young wrote:
>>On 7/26/07, Greg KH <gregkh@suse.de> wrote:
>> On Thu, Jul 26, 2007 at 11:03:54AM +0000, Dave Young wrote:
>> > Use mutex instead of semaphore in sysfs/file.c : sys_buffer.
>>
>> Thanks, it's in my queue, but I'm at a conference this week, so I'll get
>> to it on monday, sorry for the delay.
>>
>Hi, thank you. I'm not sure why it's ignored, I think maybe it should
>be splitted to two patches.
>
>Andrew has added this one to -mm tree. I'm happy to hear from you. I
>will send the seperated header cleanup patch again. gmail will convert
> tab to white space, so I have to send another post.

Well, it seems that you use web browsers to visit gmail. Can you try to
use an email client, such as claws mail, mutt, or even git-send-email?
I am using gmail with mutt, tabs aren't replaced.

Regards!

-- 
To do great work, you have to have a pure mind. You can think only about the
mathematics. Everything else is human weakness. Accepting prizes is showing
weakness.

