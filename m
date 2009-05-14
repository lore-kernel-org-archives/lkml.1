Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZENUTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZENUTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZENUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:19:28 -0400
Received: from h155.mvista.com ([63.81.120.155]:12556 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbZENUT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:19:28 -0400
Message-ID: <4A0C7CCB.1040805@ru.mvista.com>
Date: Fri, 15 May 2009 00:19:23 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ide: pass number of ports to ide_host_{alloc,add}()
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <20090513205222.28638.19386.sendpatchset@localhost.localdomain> <4A0C6A27.7010703@ru.mvista.com> <200905142151.15854.bzolnier@gmail.com>
In-Reply-To: <200905142151.15854.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>> @@ -467,7 +467,7 @@ icside_register_v6(struct icside_state *
>>>  	struct ide_host *host;
>>>  	unsigned int sel = 0;
>>>  	int ret;
>>> -	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
>>> +	hw_regs_t hw[2], *hws[] = { &hw[0], NULL };
>>>       
>>     I wonder if there's an old bug here since I'm not seeing when hws[1] is 
>> set to non-NULL -- despite there are apparently two ports?
>>
>>     Indeed, this bug seems to date back to the 'struct ide_host' 
>> introduction, see this:
>>  
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=48c3c1072651922ed153bcf0a33ea82cf20df390#patch1...
>>     
>
> Care to send a fix?
>   

   I will...

MBR, Sergei


