Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0BHOO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:14:58 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:52427 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab0BHOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:14:57 -0500
Message-ID: <d9774bfd6bb37cc5cebf74187b4f9b24.squirrel@www.loen.fr>
In-Reply-To: <4B6CBE4B.703@oracle.com>
References: <201002052332.o15NW0AO027963@imap1.linux-foundation.org>
    <4B6CBE4B.703@oracle.com>
Date: Mon, 8 Feb 2010 14:14:54 -0000 (GMT)
Subject: Re: mmotm 2010-02-05-15-06 uploaded (pca953x)
From: "Marc Zyngier" <maz@misterjones.org>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Ben Gardner" <bgardner@wabtec.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, bgardner@wabtec.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 02/05/10 15:06, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-02-05-15-06 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://zen-kernel.org/kernel/mmotm.git
>>
>> It contains the following patches against 2.6.33-rc6:
>
>
> Should this driver depend on ARM?
>
> drivers/gpio/pca953x.c:374: error: implicit declaration of function
> 'set_irq_flags'
> drivers/gpio/pca953x.c:374: error: 'IRQF_VALID' undeclared (first use in
> this function)
>
>
> These (function & macro) are only available in arch/arm/ AFAICT.

I posted an updated patch (http://patchwork.kernel.org/patch/77418/) that
fixes this issue, and integrates another fix by Andrew Morton.

The driver itself is completely generic, and should not be limited to the
ARM architecture.

        M.
-- 
And if you don't know where you're going, any road will take you there...


