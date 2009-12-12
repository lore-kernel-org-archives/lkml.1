Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbZLLAQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbZLLAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762892AbZLLAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:16:24 -0500
Received: from aglcosbs05.cos.agilent.com ([192.25.218.36]:60025 "EHLO
	aglcosbs05.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762864AbZLLAQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:16:16 -0500
X-Greylist: delayed 781 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 19:16:16 EST
Message-ID: <4B22DD89.2020901@agilent.com>
Date: Fri, 11 Dec 2009 16:02:17 -0800
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       hugh <hugh@veritas.com>, linux-mm <linux-mm@kvack.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
In-Reply-To: <1228379942.5092.14.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2009 00:02:22.0598 (UTC) FILETIME=[6129BA60:01CA7ABE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm taking another look at the changes that were submitted in

http://lkml.org/lkml/2008/12/3/453

to see if they can be made more palatable.


In http://lkml.org/lkml/2008/12/4/64 you wrote:

> Why not create another special device that will give you DMA memory when
> you mmap it? That would also allow you to obtain the physical address
> without this utter horrid hack of writing it in the mmap'ed memory.
> 
> /dev/uioN-dma would seem like a fine name for that.


I understand the main objection was the hack to return the physical
address of the allocated DMA buffer within the buffer itself amongst
some other things.

Your suggestion was to create /dev/uioN-dma for the purpose of
allocating DMA memory.

I'm having trouble figuring out how this would help to return the
physical (bus) address of the DMA memory in a more elegant manner.

What idea did you have for the userspace program to obtain
the physical (bus) of the allocated DMA memory buffer?


Earl


