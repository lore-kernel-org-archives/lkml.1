Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0CJVg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:36:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39348
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932128Ab0CJVg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:36:28 -0500
Date: Wed, 10 Mar 2010 13:36:46 -0800 (PST)
Message-Id: <20100310.133646.144946890.davem@davemloft.net>
To: yinghai@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B981049.3040607@kernel.org>
References: <20100310.133035.84824445.davem@davemloft.net>
	<20100310.133321.134330563.davem@davemloft.net>
	<4B981049.3040607@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 10 Mar 2010 13:34:01 -0800

> On 03/10/2010 01:33 PM, David Miller wrote:
>> From: David Miller <davem@davemloft.net>
>> Date: Wed, 10 Mar 2010 13:30:35 -0800 (PST)
>> 
>>> From: Yinghai Lu <yinghai@kernel.org>
>>> Date: Wed, 10 Mar 2010 13:24:27 -0800
>>>
>>>> use early_res/fw_memmap to replace lmb, so could use early_res replace bootme
>>>> later.
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> Why?  What does early_res/fw_memmap do that lmb cannot?
> 
> try to remove bootmem layer.

And LMB cannot fill this void with some minor modifications?
