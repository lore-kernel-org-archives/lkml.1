Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZFCGRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZFCGRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZFCGQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:16:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:43498 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZFCGQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:16:56 -0400
Message-ID: <4A26129E.1080008@windriver.com>
Date: Wed, 03 Jun 2009 14:05:18 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: wu zhangjin <wuzhangjin@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2 2/6] mips dynamic function tracer support
References: <cover.1243604390.git.wuzj@lemote.com>	 <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>	 <4A22281B.7020908@windriver.com> <b00321320906020915n7ba241eqb3cb0de877af514d@mail.gmail.com>
In-Reply-To: <b00321320906020915n7ba241eqb3cb0de877af514d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 06:15:33.0455 (UTC) FILETIME=[B3D75DF0:01C9E412]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wu zhangjin wrote:
> hi,
> 
> sorry, I'm so late to reply your E-mail, a little busy these days.
>>
>> }
>> ----------arch/mips/kernel/module.c:apply_r_mips_26_rel()-------------------
>>
>> v is kernel _mcount's address, location is the address of the instrution
>> that should be relocated;
>>
>> To resolve this problem, we may need to do more work, either on gcc or on
>> the kernel. So I want to hear your test result and if you have solution,
>> please let me know.
>>
> 
> yes, current version of mips-specific dynamic ftrace not support modules yet.
> 
> there is similar solution implemented in PowerPC(something named trampoline),
> although I did not look into it, but I'm sure we can implement the
> mips-specific one
> via imitating it.
Good hit. I may have a look on Powerpc implementation.

> 
> and currently, I'm planning to fix it in the -v3 of mips-specific
> ftrace support.
OK. I'm looking forward to your -v3 patches.

Thanks.
Liming Wang
> 
> best wishes,
> Wu Zhangjin
> 

