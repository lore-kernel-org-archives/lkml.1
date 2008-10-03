Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYJCHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYJCHkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYJCHkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:40:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbYJCHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:40:36 -0400
Message-ID: <48E5CC5F.4020300@zytor.com>
Date: Fri, 03 Oct 2008 00:40:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com> <20081003003237.04469201@werewolf.home> <20081003073727.GC4950@elte.hu>
In-Reply-To: <20081003073727.GC4950@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>> +++ arch/x86/kernel/cpu/mtrr/if.c     2008-10-03 00:22:34.000000000 +0200
>> @@ -16,7 +16,7 @@
>>  static const char *const mtrr_strings[MTRR_NUM_TYPES] =
>>  {
>>      "uncachable",               /* 0 */
>> -    "write-combining",          /* 1 */
>> +    "write-combine",            /* 1 */
> 
> hm, maybe this bit could confuse versions of Xorg that modifies 
> /proc/mtrr - i.e. this could be part of the ABI towards user-space. 
> We'll see.
> 

By the way, this is just plain wrong; the cachability name is "Write 
Combining (WC)" not "write-combine".

	-hpa
