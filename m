Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab0BBAfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:35:18 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:49920 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0BBAfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:35:16 -0500
Cc: linux-kernel@vger.kernel.org, jkmair@cs.otago.ac.nz
Message-Id: <64D996A4-EAF2-4E90-A590-327BE0AE5B63@cs.otago.ac.nz>
From: zhiyi <zhuang@cs.otago.ac.nz>
To: Borislav Petkov <petkovbb@googlemail.com>
In-Reply-To: <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Date: Tue, 2 Feb 2010 13:35:11 +1300
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz> <20100130171804.GA2348@liondog.tnic> <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz> <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/02/2010, at 2:57 AM, Borislav Petkov wrote:

> On Sun, Jan 31, 2010 at 11:59 PM, zhiyi <zhuang@cs.otago.ac.nz> wrote:
>> My module worked for a kernel 2.6.29 with CONFIG_NR_CPUS=64 on my  
>> dual
>> quad-core AMD Opteron. The value of nr_cpu_ids I got from the same  
>> module
>> was correct (8).
>
> This could mean that your include/generated/autoconf.h, which is  
> used by
> external modules, is not updated and contains CONFIG_NR_CPUS=8.

I have checked include/linux/autoconf.h in my linux src and found
#define CONFIG_NR_CPUS 64

but I don't see any dir like "generated" under include/

By the way, I compiled my module independent of the compilation of  
Linux tree, i.e. after the kernel is compiled and booted.

Cheers,
Zhiyi


> Do
>
> make mrproper
>
> in your kernel directory by moving your .config out of the way first  
> and
> then rebuild your kernel and external module(s). nr_cpu_ids should  
> pick
> up the updated CONFIG_NR_CPUS value from your .config.
>
> -- 
> Regards/Gruss,
> Boris
>


