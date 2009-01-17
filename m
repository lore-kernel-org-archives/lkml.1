Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZAQEVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZAQEVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 23:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZAQEVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 23:21:15 -0500
Received: from kuber.nabble.com ([216.139.236.158]:35814 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZAQEVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 23:21:15 -0500
Message-ID: <21512985.post@talk.nabble.com>
Date: Fri, 16 Jan 2009 20:21:14 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
In-Reply-To: <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <21512362.post@talk.nabble.com> <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am not an expert, just started doing some kernel programming and code
reading, so as far as I understand, memory can be either mapped to user
space or kernel space, if its neither in user and kernel, as you said, the
division is not easy, where will the memory be mapped to, is there any other
special region ?

Thanks


Bryan Donlan wrote:
> 
> On Fri, Jan 16, 2009 at 9:56 PM, sidc7 <siddhartha.chhabra@gmail.com>
> wrote:
>>
>> The kernel maintains a free list of pages that are free in physical
>> memory. I
>> was wondering, are these pages in the kernel space ? They are not mapped
>> to
>> any of the user address space for sure, so will they be in the kernel
>> memory
>> ?
> 
> Of course. Note that much of user address space is also mapped into
> kernel address space (all of it, in fact, unless you're on a 32-bit
> x86 system with PAE and more than 3G or so of RAM), so such a clear
> division isn't quite that easy :)
> 
> All the gory details are in mm/page_alloc.c and mm/slab.c (or slub.c
> or slob.c, depending on your build configuration).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/Kernel-vs-user-memory-tp21512362p21512985.html
Sent from the linux-kernel mailing list archive at Nabble.com.

