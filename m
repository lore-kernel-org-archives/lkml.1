Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZEONB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZEONB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZEONBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:01:19 -0400
Received: from india.einfochips.com ([203.88.139.151]:3241 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753411AbZEONBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:01:18 -0400
Message-ID: <4A0D66C8.4000902@einfochips.com>
Date: Fri, 15 May 2009 18:27:44 +0530
From: Viral Mehta <viral.mehta@einfochips.com>
Organization: eIbfochips Ltd.
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Shivdas Gujare <shivdas.tech@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Understanding kernel Oops while using M-USB
References: <cf70f0210905142347y7738d194k5a616e7d9e4bf092@mail.gmail.com>
In-Reply-To: <cf70f0210905142347y7738d194k5a616e7d9e4bf092@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Shivdas Gujare wrote:
> Following is a part of Oops on BeagleBoard, which I am trying to understand...
> I have pasted complete Oops at http://pastie.org/478896
>
> [<c0036d24>] (omap3_pm_idle+0x0/0x120) from [<c002c184>] (cpu_idle+0x40/0x60)
> [<c002c144>] (cpu_idle+0x0/0x60) from [<c0299bfc>] (rest_init+0x58/0x6c)
>  r5:c037ee8c r4:c0387d38
> [<c0299ba4>] (rest_init+0x0/0x6c) from [<c0008a00>] (start_kernel+0x260/0x2b8)
> [<c00087a0>] (start_kernel+0x0/0x2b8) from [<80008034>] (0x80008034)
>
> --------------------end of oops------------------
> c00087a0(virtual address of start_kernel) + 0x260(offset) = c0008a00
> (value in square bracket above)
> where c0008a00 is the address of next instruction after branch
> instruction to c0299ba4(i.e rest_init)
>
> But here, I didn't understood what is 0x2b8 from
> (start_kernel+0x260/0x2b8). i.e. 0x260 is a offset from start_kernel
> but what is 0x2b8?
>   
0x2b8 is a function size.
> Also what address 0x80008034 points to?
>
> I tried to analyze this using "arm-none-linux-gnueabi-objdump -D vmlinux".
>
> I what general scenarios "Unable to handle kernel paging request at
> virtual address" this message gets printed?
>   
vim your_kernel_src_dir/Documentation/oops-tracing.txt

-- 
Thanks, Viral Mehta, Embedded Software Engineer, www.einfochips.com
