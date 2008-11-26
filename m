Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYKZWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYKZWhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYKZWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:37:23 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:40499 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYKZWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:37:22 -0500
Date: Wed, 26 Nov 2008 14:35:54 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Paul Mackerras <paulus@samba.org>
cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] of_gpio: Return GPIO flags from of_get_gpio()
In-Reply-To: <18733.49643.63081.163437@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0811261423120.5161@t2.domain.actdsltmp>
References: <20081030111500.GB22008@oksana.dev.rtsoft.ru>
 <1225418589-8545-1-git-send-email-tpiepho@freescale.com>
 <20081126162033.GA13397@oksana.dev.rtsoft.ru> <18733.49643.63081.163437@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Paul Mackerras wrote:
> Anton Vorontsov writes:
>
>> Can we apply it? Paul, Benjamin?
>>
>> The patchwork url for this patch is:
>> http://patchwork.ozlabs.org/patch/6650/
>>
>>
>> Thanks!
>>
>>>  drivers/mtd/nand/fsl_upm.c              |    2 +-
>>>  drivers/net/fs_enet/fs_enet-main.c      |    2 +-
>>>  drivers/net/phy/mdio-ofgpio.c           |    4 ++--
>>>  drivers/of/gpio.c                       |   13 ++++++++++---
>>>  drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
>>>  include/linux/of_gpio.h                 |   21 +++++++++++++++++----
>>>  6 files changed, 32 insertions(+), 12 deletions(-)
>
> That would need acks from Jeff Garzik and David Woodhouse.
>
> Alternatively you could add a new function (called, for instance,
> of_get_gpio_flags) with the extra parameter to eliminate the need to
> change any drivers at this stage, since they all seem to pass NULL for
> the flags argument.

But if we did this every time any exported function needs to change, think
how bloated the API would be with cruft.
