Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbZAQGeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbZAQGeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZAQGe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:34:28 -0500
Received: from kuber.nabble.com ([216.139.236.158]:36381 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZAQGe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:34:28 -0500
Message-ID: <21513615.post@talk.nabble.com>
Date: Fri, 16 Jan 2009 22:34:27 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
In-Reply-To: <49717A28.2060106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <21512362.post@talk.nabble.com> <49717A28.2060106@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If I am not mistaken, Linux kernel is a high memory kernel, hence for Linux
kernel, nothing will be mapped to the kernel space, other than the memory
beyond 896MB which is the kernel's virtual address space. Am I right on
this?

Thanks


H. Peter Anvin wrote:
> 
> sidc7 wrote:
>> The kernel maintains a free list of pages that are free in physical
>> memory. I
>> was wondering, are these pages in the kernel space ? They are not mapped
>> to
>> any of the user address space for sure, so will they be in the kernel
>> memory
>> ?
> 
> On a non-highmem kernel, they will be -- ALL memory is mapped in kernel
> space on non-highmem kernels.  For highmem kernels, they will generally
> not be mapped at all, unless they are lowmem pages.
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/Kernel-vs-user-memory-tp21512362p21513615.html
Sent from the linux-kernel mailing list archive at Nabble.com.

