Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbZLRQRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbZLRQRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbZLRQRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:17:24 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:58781 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932111AbZLRQRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:17:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
X-IronPort-AV: E=Sophos;i="4.47,419,1257116400";   d="scan'208";a="38467914"
Message-id: <4B2BAAF7.2000108@nets.rwth-aachen.de>
Date: Fri, 18 Dec 2009 17:16:55 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-geode@bombadil.infradead.org
Subject: Re: 2.6.33-rc1 compile error (geode watchdog / mfgpt related)
References: <4B2B79D3.1070706@nets.rwth-aachen.de>
 <20091218110358.66c4ec17@mycelium.queued.net>
In-reply-to: <20091218110358.66c4ec17@mycelium.queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon wrote:
> On Fri, 18 Dec 2009 13:47:15 +0100
> Arnd Hannemann
> <hannemann@nets.rwth-aachen.de> wrote:
> 
>> Hi,
>>
>> 2.6.33-rc1 does not compile for me:
>>
>>   CC      drivers/watchdog/geodewdt.o
>> drivers/watchdog/geodewdt.c: In function 'geodewdt_ping':
>> drivers/watchdog/geodewdt.c:55: error: implicit declaration of
>> function 'geode_mfgpt_write' drivers/watchdog/geodewdt.c: In function
>> 'geodewdt_probe': drivers/watchdog/geodewdt.c:220: error: implicit
>> declaration of function 'geode_mfgpt_alloc_timer'
>> drivers/watchdog/geodewdt.c:235: error: implicit declaration of
>> function 'geode_mfgpt_toggle_event' make[2]: ***
>> [drivers/watchdog/geodewdt.o] Error 1 make[1]: *** [drivers/watchdog]
>> Error 2 make: *** [drivers] Error 2
>>
> 
> Whoops, I missed that driver; sorry about that.
> 
> The patch below should fix it..

Thanks, your patch indeed fixes the problem.

Best regards,
Arnd
