Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab0CJWLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:11:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:60613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932813Ab0CJWLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:11:34 -0500
Message-ID: <4B9818CE.7090809@kernel.org>
Date: Wed, 10 Mar 2010 14:10:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
References: <20100310.133035.84824445.davem@davemloft.net>	<20100310.133321.134330563.davem@davemloft.net>	<4B981049.3040607@kernel.org> <20100310.133646.144946890.davem@davemloft.net>
In-Reply-To: <20100310.133646.144946890.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 01:36 PM, David Miller wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Wed, 10 Mar 2010 13:34:01 -0800
> 
>> On 03/10/2010 01:33 PM, David Miller wrote:
>>> From: David Miller <davem@davemloft.net>
>>> Date: Wed, 10 Mar 2010 13:30:35 -0800 (PST)
>>>
>>>> From: Yinghai Lu <yinghai@kernel.org>
>>>> Date: Wed, 10 Mar 2010 13:24:27 -0800
>>>>
>>>>> use early_res/fw_memmap to replace lmb, so could use early_res replace bootme
>>>>> later.
>>>>>
>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> Why?  What does early_res/fw_memmap do that lmb cannot?
>>
>> try to remove bootmem layer.
> 
> And LMB cannot fill this void with some minor modifications?

early_res array could be increased automatically...

could be something like:
keep lmb.memory part, and use early_res for reserved parts...

maybe could try to make fw_memmap.c more simple.

Yinghai
