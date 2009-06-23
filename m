Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZFWKnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZFWKnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZFWKnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:43:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49088
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbZFWKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:43:12 -0400
Date: Tue, 23 Jun 2009 03:43:16 -0700 (PDT)
Message-Id: <20090623.034316.149816033.davem@davemloft.net>
To: elendil@planet.nl
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906221604.17915.elendil@planet.nl>
References: <200906220843.14337.elendil@planet.nl>
	<200906221321.44672.bzolnier@gmail.com>
	<200906221604.17915.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Mon, 22 Jun 2009 16:04:15 +0200

> On Monday 22 June 2009, you wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Subject: [PATCH] ide: fix handling of unexpected IRQs vs request_irq()
>>
>> Add ide_host_enable_irqs() helper and use it in ide_host_register()
>> before registering ports.  Then remove no longer needed IRQ unmasking
>> from in init_irq().
>>
>> This should fix the problem with "screaming" shared IRQ on the first
>> port (after request_irq() call while we have the unexpected IRQ pending
>> on the second port) which was uncovered by my rework of the serialized
>> interfaces support.
> 
> Thanks Bart. This does solve the "nobody cared" problem.
> Tested-by: Frans Pop <elendil@planet.nl>

I've applied this patch to my tree, thanks everyone!
