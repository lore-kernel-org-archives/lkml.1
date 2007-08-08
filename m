Return-Path: <linux-kernel-owner+w=401wt.eu-S936000AbXHHAHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936000AbXHHAHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760867AbXHHAHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:07:06 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45366 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623AbXHHAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:07:03 -0400
Date: Tue, 07 Aug 2007 18:05:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: i386: kernel boot fail at check_irq_resend:69
In-reply-to: <fa.Jxf3sOqjIQoBfp5keWQZ/p/XSd0@ifi.uio.no>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Li Yang-r58472 <LeoLi@freescale.com>, hpa@zytor.com,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <46B908DE.7030602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.s/gpFOoJ8PMyPpXRJ4FrnAalSPA@ifi.uio.no>
 <fa.wDaJQAUs/L/XQkqGZHHUpRgZzvg@ifi.uio.no>
 <fa.Jxf3sOqjIQoBfp5keWQZ/p/XSd0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
>> On 8/7/07, Li Yang-r58472 <LeoLi@freescale.com> wrote:
>>   -----Original Message-----
>>> From: linux-kernel-owner@vger.kernel.org
>>> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Dave Young
>>> Sent: Tuesday, August 07, 2007 2:32 PM
>>> To: hpa@zytor.com
>>> Cc: LKML
>>> Subject: i386: kernel boot fail at check_irq_resend:69
>>>
>>> Hi,
>>> The kernerl 2.6.23-rc1-mm2 boot fail at check_irq_resend:69
>>>        > if (WARN_ON_ONCE(desc->handle_irq != handle_edge_irq))
>>>        >        return;
>> Failed?  It's just a kernel Badness for me, and the boot can be finished.
> 
> No, my kernel panic after this. noapic does not help too.
> Regards
> dave

That warning should not cause a panic. Is there another message after it?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

