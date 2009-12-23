Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZLWWAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZLWWAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZLWWAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:00:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768AbZLWWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:00:44 -0500
Date: Wed, 23 Dec 2009 14:00:46 -0800 (PST)
Message-Id: <20091223.140046.39189587.davem@davemloft.net>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 15/37] sparc,sunzilog: Add console polling support for
 sunzilog serial driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B3291AD.6070104@windriver.com>
References: <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
	<20091223.135028.112586698.davem@davemloft.net>
	<4B3291AD.6070104@windriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 23 Dec 2009 15:54:53 -0600

> David Miller wrote:
>> From: Jason Wessel <jason.wessel@windriver.com>
>> Date: Wed, 23 Dec 2009 15:19:28 -0600
>>
>>   
>>> +static void sunzilog_put_poll_char(struct uart_port *port,
>>> +			unsigned char ch)
>>> +{
>>> +	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *)port;
>>> +
>>> +	sunzilog_putchar(&up->port, ch);
>>> +	udelay(2);
>>> +
>>> +}
>>> +#endif /* CONFIG_CONSOLE_POLL */
>>>     
>>
>> Just curious, what is the udelay() for?
>>   
> 
> This was copied from zm.c driver.  I don't think the HW needs it, I'll
> retest and purge it.
 ...
> Consider it done.

Thanks.
