Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYGaBV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYGaBV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYGaBVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:21:17 -0400
Received: from 215.47.DSNET ([211.144.215.47]:46257 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751689AbYGaBVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:21:17 -0400
X-AuditID: ac189297-ab9fcbb000003fd3-2e-48911b856b75
Message-ID: <48910E9A.9060103@alcatel-lucent.com>
Date: Thu, 31 Jul 2008 09:00:10 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com> <200807291713.29580.bzolnier@gmail.com> <488FBC6F.2080800@alcatel-lucent.com> <200807302143.37693.bzolnier@gmail.com>
In-Reply-To: <200807302143.37693.bzolnier@gmail.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 01:00:00.0686 (UTC) FILETIME=[C236D4E0:01C8F2A8]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 30 July 2008, gshan wrote:
>
> [...]
>  
>   
>> The IRQ routing issue has been fixed. IRQ routing system
>> on my board is somewhat complicated: i8259->mlba (FPGA based
>> PCI device)->MV64460(system controller). I forgot to set MV64460
>> IRQ pin to level sensitive and edge sensitive was used, which caused
>> interrupt lost finally. After changing this to level sensitive, everything
>> seems fine. Now, the problem isn't interrupt lost, but suspending DMA
>> operations.
>>     
>
> Thanks for explaining this.
>
>   
>>> Also is the problem still present in 2.6.26 or 2.6.27-rc1?
>>>
>>> [ I don't see an information about the kernel version that is
>>>   being used in either of threads? ]
>>>   
>>>       
>> Sorry, I'm using 2.6.21 kernel.
>>     
>
> Would be great to try with some recent one, the issue may have been
> fixed already (which is quite likely given a number of bugfixes that
> went in recent kernels).
>   
I tried to searched in bugzilla.kernel.org and didn't find
there has fix on this issue. Yesterday, Jeff suggested me
to turn to ata driver for PIIX4. I tried this yesterday but still
have some problems to make PIIX4 workable under ata
driver. I will continue working on this today.

Gavin

> Thanks,
> Bart
>   

