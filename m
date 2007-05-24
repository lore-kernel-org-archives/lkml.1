Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbXEXQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbXEXQSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750731AbXEXQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:18:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60433 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXEXQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:18:43 -0400
Message-ID: <4655BC2D.2070701@oracle.com>
Date: Thu, 24 May 2007 09:24:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com> <Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 22 2007 12:09, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Add "notime" boot option to prevent timing data from being printed on
>> each printk message line.
>>
>> We've seen a few cases of 'time' data locking problems (possibly
>> involving netconsole or net drivers).  If a kernel is built with
>> CONFIG_PRINTK_TIME=y, it may have a boot locking hang.  Booting
>> with "notime" may (i.e., could) prevent the lock hang and allow the
>> kernel to boot successfully, without requiring a kernel rebuild.
> 
> Wonderful, now we have _three_ options to control time...
> 
> 	time=<bool>
> 	printk.time=<bool>
> 	notime=<bool>

Currently the middle one is "printk.printk_time".
And the first and last are just "time" and "notime", without a bool value.

And as I wrote later, I'd be happy to remove #s 1 and 3 and use only the
middle one, renaming the param so that it _is_ printk.time.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
