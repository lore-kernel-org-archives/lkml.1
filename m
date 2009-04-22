Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZDVHow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZDVHow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZDVHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:44:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60683
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbZDVHok convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:44:40 -0400
Date: Wed, 22 Apr 2009 00:44:32 -0700 (PDT)
Message-Id: <20090422.004432.227765146.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: jianjun@zeuux.org, jon.lin@vatics.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
From: David Miller <davem@davemloft.net>
In-Reply-To: <49EDA040.5040600@cosmosbay.com>
References: <20090421.015235.23457775.davem@davemloft.net>
	<20090421094825.GA6752@ubuntu>
	<49EDA040.5040600@cosmosbay.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 21 Apr 2009 12:30:24 +0200

> Amos Kong a écrit :
>> ...
>>  While ifconfig eth0 up kernel calls open() of 8139 driver(8139too.c).
>>  In rtl8139_hw_start() of rtl8139_open(), 8139 driver enable RX before setting up the DMA
>>  buffer address. In this interval where RX was enabled and DMA buffer address is not yet set
>>  up, any incoming broadcast packet would be send to a strange physical address:
>>  0x003e8800 which is the default value of DMA buffer address.
>>  Unfortunately, this address is used by Linux kernel. So kernel panics.
>>  This patch fix it by setting up DMA buffer address before RX enabled and everything is fine
>>  even under broadcast packets attack.
>> 
>> Signed-off-by: Jonathan Lin <jon.lin@vatics.com>
>> Signed-off-by: Amos Kong <jianjun@zeuux.org>
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> 
> Thanks Amos and Jonathan

Applied, thanks everyone.
