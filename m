Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZGXHf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZGXHf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZGXHf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:35:56 -0400
Received: from mail.atmel.fr ([81.80.104.162]:60014 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZGXHf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:35:56 -0400
Message-ID: <4A696449.7050303@atmel.com>
Date: Fri, 24 Jul 2009 09:35:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: maciej.sosnowski@intel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
References: <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>	 <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com> <e9c3a7c20907231013k3d5e8c89w1069e8509539438f@mail.gmail.com>
In-Reply-To: <e9c3a7c20907231013k3d5e8c89w1069e8509539438f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams :
> On Wed, Jul 22, 2009 at 11:04 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
>> This patch for at_hdmac adds the slave transfers capability to the Atmel DMA
>> controller available on some AT91 SOCs. This allow peripheral to memory and
>> memory to peripheral transfers with hardware handshaking.
>>
>> Slave structure for controller specific information is passed through channel
>> private data. This at_dma_slave structure is defined in at_hdmac.h header file
>> and relative hardware definition are moved to this file from at_hdmac_regs.h.
>> Doing this we allow the channel configuration from platform definition code.
>>
>> This work is intensively based on dw_dmac and several slave implementations.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> Seems straightforward and self contained, applied.  Just curious which
> drivers will take advantage of this slave capability?  As it stands I
> do not see any in-tree users of at_hdmac beyond dmatest?

Well, in fact the same as dw_dmac: atmel-mci. Adaptation of other
drivers are coming: probably ac97 and spi interfaces.

The patches for adaptation of atmel-mci to at_hdmac are coming...

Best regards,
-- 
Nicolas Ferre

