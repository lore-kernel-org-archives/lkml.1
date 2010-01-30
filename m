Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595Ab0A3LvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0A3LvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085Ab0A3LvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:51:19 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52382 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0A3LvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:51:19 -0500
Message-ID: <4B641D35.4060709@dcl.info.waseda.ac.jp>
Date: Sat, 30 Jan 2010 20:51:17 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Add util/include/linux/config.h for including generated
 autoconf.h of kernel
References: <4B6133DF.9080207@dcl.info.waseda.ac.jp> <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100128222713.GC2585@brick.ozlabs.ibm.com>
In-Reply-To: <20100128222713.GC2585@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010年01月29日 07:27), Paul Mackerras wrote:
> On Thu, Jan 28, 2010 at 11:28:48PM +0900, Hitoshi Mitake wrote:
>
>    
>> I'd like to add util/include/linux/config.h,
>> this header file includes autoconf.h which is generated
>> by build phase of kernel.
>>
>> This makes building of perf depend on building of kernel.
>> It's a little dirty. But perf has tight relation
>> of its kernel, so I don't think that it is a serious problem.
>>
>> My original purpose of making this patch is
>> knowing size of void *.
>> If config.h is available,
>> CONFIG_ARCH_PHYS_ADDR_T_64BIT will be provided for source of perf,
>> we can know size of void * by this config.
>>
>> How do you think?
>>      
> How will this work if I built the kernel in a separate object
> directory (e.g., using "make O=../builddir vmlinux")?  I think that
> trying to include generated files will fail in that case.
>
> In general I think that tying perf to the kernel config is a bad idea.
>
> Paul.
>
>    

Ah, sorry, I've forgot about the case of
separated build directory.

And I found the way to use memcpy() and sent patch series.
I sent the patch series, based on the memcpy() way.

Thanks
Hitoshi

