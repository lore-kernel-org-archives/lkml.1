Return-Path: <linux-kernel-owner+w=401wt.eu-S965993AbXBOP5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965993AbXBOP5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965998AbXBOP5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:57:03 -0500
Received: from chicken.visionpro.com ([63.91.95.13]:33297 "EHLO
	chicken.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965993AbXBOP5C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:57:02 -0500
X-Ninja-PIM: Scanned by Ninja
X-Ninja-AttachmentFiltering: (no action)
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: FW: UI getting "killed" randomely on Fedora machines
Date: Thu, 15 Feb 2007 07:56:59 -0800
Message-ID: <14CFC56C96D8554AA0B8969DB825FEA001C3A3F3@chicken.machinevisionproducts.com>
Thread-Topic: UI getting "killed" randomely on Fedora machines
thread-index: AcdQjJBNzpYDFbx/EduUqAAwZXmXDgAjUYTQ
From: "Brian D. McGrew" <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning all,

We're seeing a problem where an application is being killed from what
appears to be an out of memory issue.  Can anyone offer any insight on
this for me?

Thanks!

-brian

Brian D. McGrew        { brian@visionpro.com ||
brian@doubledimension.com }
--
> Do not read this email while waxing that cat! 

-----Original Message-----
From: Greg Frinchaboy 
Sent: Wednesday, February 14, 2007 3:05 PM
To: Olga Balakina; Brian D. McGrew
Cc: Kanyu Tsang
Subject: Re: UI getting "killed" randomely on Fedora machines

I do not have any experience with oom-killer.  Brian?

Why are we getting out of memory?  Are you running with the JEditor?


On 2/14/07 2:44 PM, "Olga Balakina" <olga@visionpro.com> wrote:

> 
> As you may be aware this is happening from time to time on our
machines,
> DPMS, and now 5.2 doing 3D inspections. Inspection is being "killed"
after
> random number, no coredump is created. I am looking at the current
> happening on mvp-244 during 3D runs. This is what I found. All the
kills
> coincide with kernel messages like this one:
> 
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000] oom-killer:
> gfp_mask=0x201d2, order=0
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c0145d6e>]
> out_of_memory+0x9d/0xdf
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c0146e9b>]
> __alloc_pages+0x2a9/0x2d1
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c014354f>]
> page_cache_read+0x55/0xc4
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c01437df>]
> filemap_nopage+0x221/0x371
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c0150254>]
> do_no_page+0x8d/0x2c7
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c02fd32c>]
> schedule+0x37c/0x78c
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c02fd35d>]
> schedule+0x3ad/0x78c
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c01507d4>]
> __handle_mm_fault+0x25b/0x2f1
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c0135468>]
> hrtimer_cancel+0xa/0x10
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c011812a>]
> do_page_fault+0x1b0/0x5c4
> Feb 14 14:06:49 AI-8004 kernel: [17190077.644000]  [<c0117f7a>]
> do_page_fault+0x0/0x5c4
> 
> After investigation I've found that kernel in some cases when memory
usage
> is high kills processes of such a high usage at it's discretion.
> oom-killer (out of memory killer) is what is invoked on our ui doing
> inspections.
> 
> So, Brian and Greg, I know that it is possible to disable oom-killer
> on kernel level, just don't have the detales.
> 
> Do you have experience with that?
> 
> Thanks, Olga
> 


