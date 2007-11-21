Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbXKUIqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbXKUIqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbXKUIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:46:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:50698 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbXKUIqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:46:00 -0500
Message-ID: <4743EFF8.9010307@qumranet.com>
Date: Wed, 21 Nov 2007 10:44:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org> <4743EF47.5000203@linux.vnet.ibm.com>
In-Reply-To: <4743EF47.5000203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Andrew Morton wrote:
>   
>> On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>     
>>> The make headers_check fails,
>>>
>>>   CHECK   include/linux/usb/gadgetfs.h
>>>   CHECK   include/linux/usb/ch9.h
>>>   CHECK   include/linux/usb/cdc.h
>>>   CHECK   include/linux/usb/audio.h
>>>   CHECK   include/linux/kvm.h
>>> /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires asm/kvm.h, which does not exist in exported headers
>>>       
>> hm, works for me, on i386 and x86_64.  What's different over there?
>>     
> Hi Andrew,
>
> It fails on the powerpc box, with allyesconfig option.
>
>   

How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

