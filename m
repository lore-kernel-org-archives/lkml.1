Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0CJXD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:03:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:52368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385Ab0CJXD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:03:27 -0500
Message-ID: <4B9824D5.8090906@kernel.org>
Date: Wed, 10 Mar 2010 15:01:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
References: <4B9818CE.7090809@kernel.org>	<20100310.141757.95833226.davem@davemloft.net>	<4B981DBD.2060303@kernel.org> <20100310.143602.266086944.davem@davemloft.net>
In-Reply-To: <20100310.143602.266086944.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 02:36 PM, David Miller wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Wed, 10 Mar 2010 14:31:25 -0800
> 
>> they are array based.
>>
>> 1. memmap is not changed after get it from firmware, <could be modified via mem= or memmap=>
>> 2. early_res at first is static array, later it will be relocated to another position if the array is not big enough.
> 
> LMB could do this too with minor modifications.
> 
> Simply make the lmb.memory and lmb.reserved be pointers, and initially
> they point into the static array(s).
> 
> Later the pointers can be repositioned to point to dynamically
> allocated memory.
> 
> So please, for the third time, please show me how LMB with some minor
> modifications is not able to satisfy your needs.

you could do it, 
need to duplicate some functions from early_res.c and fw_memmap.c
esp __check_and_double_early_res, get_free_all_memory_range

YH
