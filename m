Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYDMCYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYDMCYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 22:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYDMCYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 22:24:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:32730 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYDMCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 22:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qMNaFK7MltohecoaUcgy3sbMrD5wsc4KcckUdgEJlEhRKxcoHqTRYpqWH6pfNJXSpl+4ZQCDJa+NnvCVk6wB8Q6Jh+EUNKIwiOILxrDIQIH0RfZlIiAAHo7COt54ewXW8un8rR4tEYE77dPlQfA2yywLU8DHL8MTPQ0kQoO82tE=
Message-ID: <48016EB4.1070804@gmail.com>
Date: Sun, 13 Apr 2008 11:23:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       "Linux-Kernel, " <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Again... DMA speed too slow
References: <20080330235357.20a54963@werewolf> <20080402001640.41c103a7.akpm@linux-foundation.org>
In-Reply-To: <20080402001640.41c103a7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 30 Mar 2008 23:53:57 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
>> Hi all...
>>
>> I have tried to burn some data from the commandline with wodim (since time
>> ago I just used beasero...), and I have noticed this (media is CD, not DVD):
>>
>> Vendor_info    : 'HL-DT-ST'
>> Identification : 'DVDRAM GSA-H10N '
>> Revision       : 'JL12'
>> Device seems to be: Generic mmc2 DVD-R/DVD-RW.
>> Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
>> Driver flags   : MMC-3 SWABAUDIO BURNFREE
>> Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
>> Speed set to 8467 KB/s
>> wodim: DMA speed too slow (OK for 5x). Cannot write at speed 48x.
>> Starting to write CD/DVD at speed  48.0 in real TAO mode for single session.
>>
>> I just can burn CDs at 5x ??
>> But then the program tries to write at 48x.
>> It the DMA message really true ?

Which controller are you on?  I bet the recording itself will work fine 
on 48x.  It's probably that READ/WRITE BUFFERs are executed using PIO 
for compatibility reasons.

-- 
tejun
