Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbXIHL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbXIHL6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXIHL6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:58:07 -0400
Received: from h155.mvista.com ([63.81.120.155]:49176 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752030AbXIHL6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:58:06 -0400
Message-ID: <46E28F01.7010808@ru.mvista.com>
Date: Sat, 08 Sep 2007 16:01:05 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hpt366: MWDMA filter for SATA cards
References: <200709030019.22732.sshtylyov@ru.mvista.com> <46DB1C50.2020205@ru.mvista.com>
In-Reply-To: <46DB1C50.2020205@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:
Sergei Shtylyov wrote:

>    The patch was 4/4 of course. :-<
>     Probably I was too esctatic about the code. ;-)

    Or rarher me. :-)

>> The Marvell bridge chips used on HighPoint SATA cards do not seem to 
>> support
>> the MWDMA modes (at least that caould be seen in their so-called 
>> drivers :-),
>> so the driver needs to account for this -- to achieve this:

>> - add mdma_filter() method from the original patch by Bartlomiej 
>> Zolnierkewicz
>>   with his consent, also adding the method callout to ide_rate_filter();

>> - installed the method for all chips to only return empty mask if a 
>> SATA drive
>>   is detected onHPT372{AN]/374 chips...

>> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

>> ---
>> This patch against the current Linus' tree and unfortunately I was 
>> able to only
>> compile test it since that tree gives MODPOST warning and dies early 
>> on bootup.
>> Will hopefully try to test if/when I have time... :-)

    And it was still the same -- I'd bisected if I had time...

>> Index: linux-2.6/drivers/ide/pci/hpt366.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/ide/pci/hpt366.c
>> +++ linux-2.6/drivers/ide/pci/hpt366.c
>> @@ -1,5 +1,5 @@
>>  /*
>> - * linux/drivers/ide/pci/hpt366.c        Version 1.12    Aug 25, 2007
>> + * linux/drivers/ide/pci/hpt366.c        Version 1.13    Aug 22, 2007

>    Errr... and version shuold Aug 02 -- thought I've fixed that. :-/

    Hehe, thanks.  Those versions turned to be quite PITA a to keep.

MBR, Sergei
