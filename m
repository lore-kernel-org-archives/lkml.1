Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXEaTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXEaTzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbXEaTze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:55:34 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:38951 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578AbXEaTzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:55:33 -0400
Date: Thu, 31 May 2007 21:53:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>, kkeil@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Use menuconfig objects 4 - ISDN part 2/6
 (CONFIG_ISDN_I4L)
In-Reply-To: <465EF4F4.1090507@imap.cc>
Message-ID: <Pine.LNX.4.61.0705312152580.11140@yvahk01.tjqt.qr>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
 <Pine.LNX.4.61.0705302137560.11140@yvahk01.tjqt.qr> <465EF4F4.1090507@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 31 2007 18:16, Tilman Schmidt wrote:
>Am 30.05.2007 21:38 schrieb Jan Engelhardt:
>> --- linux-2.6.22-rc3-git1.orig/drivers/isdn/Kconfig
>> +++ linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
>> @@ -21,9 +21,7 @@ menuconfig ISDN
>>  
>>  if ISDN
>>  
>> -menu "Old ISDN4Linux"
>> -
>> -config ISDN_I4L
>> +menuconfig ISDN_I4L
>>  	tristate "Old ISDN4Linux (obsolete)"
>>  	---help---
>>  	  This driver allows you to use an ISDN-card for networking
>> @@ -44,8 +42,6 @@ if ISDN_I4L
>>  source "drivers/isdn/i4l/Kconfig"
>>  endif
>>  
>> -endmenu
>> -
>>  comment "CAPI subsystem"
>>  
>
>This results in a rather strange and inconsistent presentation in
>"make xconfig", with ISDN4Linux appearing as a subtree in the left
>pane but CAPI only visible in the right pane after selecting ISDN.

That's a gconfig/xconfig b^H missing feature.

>IMHO it looks much saner like this:

But then you'd still have to descend into ISDN4Linux to deactivate it.

> config ISDN_I4L
> 	tristate "Old ISDN4Linux (deprecated)"
> 	---help---
>@@ -44,12 +42,8 @@ if ISDN_I4L



	Jan
-- 
