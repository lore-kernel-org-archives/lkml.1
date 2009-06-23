Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbZFWNUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbZFWNUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZFWNUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:20:30 -0400
Received: from mail.atmel.fr ([81.80.104.162]:48817 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZFWNUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:20:30 -0400
Message-ID: <4A40D695.5000302@atmel.com>
Date: Tue, 23 Jun 2009 15:20:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 5/5] at91/atmel_lcdfb: add at91sam9g10 support to atmel
 LCD driver
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com> <1245341772-1689-6-git-send-email-nicolas.ferre@atmel.com> <20090618222413.GC19515@game.jcrosoft.org>
In-Reply-To: <20090618222413.GC19515@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Christophe PLAGNIOL-VILLARD :
> On 18:16 Thu 18 Jun     , Nicolas Ferre wrote:
>> From: Hong Xu <hong.xu@atmel.com>
>>
>> Modify atmel LCD driver: atmel_lcdfb for at91sam9g10.  This add a clock
>> management equivalent to at91sam9261.
>>
>> Signed-off-by: Hong Xu <hong.xu@atmel.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/video/Kconfig           |    4 ++--
>>  drivers/video/atmel_lcdfb.c     |    6 ++++--
>>  drivers/video/backlight/Kconfig |    2 +-
>>  3 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
>> index 5152168..2dbede4 100644
>> --- a/drivers/video/Kconfig
>> +++ b/drivers/video/Kconfig
>> @@ -933,7 +933,7 @@ config FB_S1D13XXX
>>  
>>  config FB_ATMEL
>>  	tristate "AT91/AT32 LCD Controller support"
>> -	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
>> +	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
> create a ARCH_ATMEL_HAS_FB then select it at the soc will allow to reduce this || xx... by
> 	depends on FB && ARCH_ATMEL_HAS_FB

Maybe we can schedule such an update on top of this patch series.
Indeed, as it impacts also AVR32, I propose to build a patch with both
architecture update once at91sam9g45 and at91sam9g10 patchsets are queued.

A proposition follows.

Regards,
-- 
Nicolas Ferre

