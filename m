Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbXKUIl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbXKUIl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXKUIlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:41:50 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:53535 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753210AbXKUIlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:41:49 -0500
Message-ID: <4743EF47.5000203@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 14:11:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org>
In-Reply-To: <20071120163240.e54beed6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> The make headers_check fails,
>>
>>   CHECK   include/linux/usb/gadgetfs.h
>>   CHECK   include/linux/usb/ch9.h
>>   CHECK   include/linux/usb/cdc.h
>>   CHECK   include/linux/usb/audio.h
>>   CHECK   include/linux/kvm.h
>> /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires asm/kvm.h, which does not exist in exported headers
> 
> hm, works for me, on i386 and x86_64.  What's different over there?
Hi Andrew,

It fails on the powerpc box, with allyesconfig option.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
