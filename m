Return-Path: <linux-kernel-owner+w=401wt.eu-S934520AbXHHOrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbXHHOrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXHHOri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:47:38 -0400
Received: from mail.atmel.fr ([81.80.104.162]:45130 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXHHOrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:47:37 -0400
Message-ID: <46B9D6EE.4040705@rfo.atmel.com>
Date: Wed, 08 Aug 2007 16:45:02 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: ?? <wux@landicorp.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] mmc: at91_mci: add multiwrite cap
References: <46B9926B.3090707@rfo.atmel.com> <20070808121147.1433d055@poseidon.drzeus.cx>
In-Reply-To: <20070808121147.1433d055@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Wed, 08 Aug 2007 11:52:43 +0200
> Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:
> 
>> From: Wu Xuan <wux@landicorp.com>
>>
>> Add multiwrite support capability.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
>> ---
> 
> Just like that? :)
> 
> If I could just bother you with testing the included patch first. Just
> load the module and insert a card. WARNING! It will eat your data, so
> do it on a test card. And remember to remove it once you're done.

Pierre,

I am a little confused : the probe function does not seem to get 
called... (I tried both module an in-kernel form / inserting sd or mmc 
cards).

The modules is correctly inserted : mmc_register_driver() returns 0.

Did I miss something ?

Regards,
-- 
Nicolas Ferre

