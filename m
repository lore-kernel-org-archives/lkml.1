Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZEYEQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZEYEQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 00:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZEYEQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 00:16:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZEYEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 00:16:35 -0400
Message-ID: <4A1A1B88.6070305@kernel.org>
Date: Mon, 25 May 2009 13:16:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, suresh.b.siddha@intel.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2.6.30-rc7] x86: remove remap percpu allocator for the
 time being
References: <4A1A0A27.4050301@kernel.org> <20090525033429.GC20687@elte.hu> <20090525033920.GD20687@elte.hu>
In-Reply-To: <20090525033920.GD20687@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 04:16:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>> @@ -365,9 +249,7 @@ void __init setup_per_cpu_areas(void)
>>>  	 * of large page mappings.  Please read comments on top of
>>>  	 * each allocator for details.
>>>  	 */
>>> -	ret = setup_pcpu_remap(static_size);
>>> -	if (ret < 0)
>>> -		ret = setup_pcpu_embed(static_size);
>>> +	ret = setup_pcpu_embed(static_size);
>>>  	if (ret < 0)
>>>  		ret = setup_pcpu_4k(static_size);
>>>  	if (ret < 0)
>> Please send a patch that only does the above chunk in essence. We 
>> can deal with the rest in .31.
> 
> I've committed the minimal patch below.

Yeap, that works too.

Thanks.

-- 
tejun
