Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbZA2XWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbZA2XWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZA2XW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:22:26 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:51612 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZA2XWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:22:25 -0500
X-BigFish: VS-49(z21eWz1432R98dR936eQ1805M103dK7cf0izz10c0jzzz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <49823A13.50703@am.sony.com>
Date: Thu, 29 Jan 2009 15:21:55 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.28-rt on PowerPC
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru> <1233270043.3833.57.camel@localhost.localdomain>
In-Reply-To: <1233270043.3833.57.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2009 23:22:07.0918 (UTC) FILETIME=[675DCCE0:01C98268]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2009-01-30 at 00:34 +0300, Anton Vorontsov wrote:
>> Hi Steven,
>>
>> I know 2.6.28-rt isn't yet ready, but I could not resist to try
>> it anyway. ;-)
>>
>> Here are few issues and ways to solve them:
>>
>> Currently the -rt tree doesn't link for arch/powerpc:
>>
>>   LD      .tmp_vmlinux1
>>   arch/powerpc/kernel/built-in.o: In function `show_interrupts':
>>   (.text+0x27bc): undefined reference to `__call_bad_lock_func'
>>   arch/powerpc/kernel/built-in.o: In function `show_interrupts':
>>   (.text+0x28b0): undefined reference to `__call_bad_lock_func'
>>   make: *** [.tmp_vmlinux1] Error 1
> 
> Thanks! I have not yet had the chance to apply any arch patches yet. I
> do plan on doing so after getting the code mostly working on x86.

Your email can at an opportune time for me...  I was starting to try
2.6.28-rt on ARM and quickly came to the conclusion that the arch
patches weren't the focus yet.  But I'm currently side-tracked with
getting my board to even boot a vanilla 2.6.28 kernel first.  Do
you expect to get to the arches in the next week or two?  If not,
I may head down that path for ARM myself.

Thanks!

-Frank Rowand


