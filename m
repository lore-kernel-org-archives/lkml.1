Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXJ2P5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXJ2P5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXJ2P5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:57:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXJ2P5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:57:31 -0400
Message-ID: <472602D3.4010007@zytor.com>
Date: Mon, 29 Oct 2007 08:57:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
References: <200710290628.l9T6SDpo012530@harpo.it.uu.se> <alpine.LFD.0.9999.0710291440570.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710291440570.3186@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
>>
>> They look like paths to the vmlinuz and initrd surrounded
>> by [ ] brackets, so I guess they come from grub.
> 
> Any chance to use serial console ?
> 
> Enable CONFIG_EARLY_PRINTK and add
>  
> earlyprintk=serial,ttyS0,115200,keep
> 
> to the kernel command line.
> 
> Can you please provide your .config file ?
> 

I doubt he's getting far enough that he's actually getting early printk. 
  I could be wrong, of course.

> I tested on my i386 box and Linus latest git boots fine:
> # uname -a
> Linux museum386 2.6.24-rc1-2a397e82 #1 PREEMPT Mon Oct 29 13:39:29 CET 2007 i386 unknown
> # cat /proc/cpuinfo
> clflush size    : 32

Hm.  This probably shouldn't be displayed when clflush isn't available...

	-hpa
