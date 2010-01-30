Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588Ab0A3LpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0A3LpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0A3Lou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:44:50 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52309 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0A3Lot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:44:49 -0500
Message-ID: <4B641BAD.7060102@dcl.info.waseda.ac.jp>
Date: Sat, 30 Jan 2010 20:44:45 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Add util/include/linux/config.h for including generated
 autoconf.h of kernel
References: <4B6133DF.9080207@dcl.info.waseda.ac.jp>	 <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1264689878.4283.2101.camel@laptop>
In-Reply-To: <1264689878.4283.2101.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010年01月28日 23:44), Peter Zijlstra wrote:
> On Thu, 2010-01-28 at 23:28 +0900, Hitoshi Mitake wrote:
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
> I think sizeof(void *).
>
>
>    

I've told about preprocessor level method.
But thanks for your advice,
I found the way to use memcpy()!

Thanks
     Hitoshi

