Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZAQGmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZAQGmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZAQGmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:42:33 -0500
Received: from kuber.nabble.com ([216.139.236.158]:59973 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZAQGmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:42:33 -0500
Message-ID: <21513643.post@talk.nabble.com>
Date: Fri, 16 Jan 2009 22:42:32 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
In-Reply-To: <49717D03.2030205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <21512362.post@talk.nabble.com> <49717A28.2060106@zytor.com> <21513615.post@talk.nabble.com> <49717D03.2030205@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One last question, which one of the two lowmem or highmem kernel is most
commonly used on contemporary linux boxes. I am guessing highmem kernel ?

Thanks for the quick replies, helped a lot


H. Peter Anvin wrote:
> 
> sidc7 wrote:
>> If I am not mistaken, Linux kernel is a high memory kernel, hence for
>> Linux
>> kernel, nothing will be mapped to the kernel space, other than the memory
>> beyond 896MB which is the kernel's virtual address space. Am I right on
>> this?
> 
> It's a compilation option, and depends on the architecture.  What you
> described is true for an i386 kernel compiled as a highmem kernel.  On
> the other hand, a 64 bit kernel is *never* highmem.
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
View this message in context: http://www.nabble.com/Kernel-vs-user-memory-tp21512362p21513643.html
Sent from the linux-kernel mailing list archive at Nabble.com.

