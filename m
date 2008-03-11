Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYCKCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYCKCcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYCKCcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:32:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:58164 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYCKCcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sDR3Qo8vXlY4RourHqJE3Bessg5jtWY0u7YWykmDyUxbxmGZ04qUhqTSAG2vlErEWxVcppcFX/U/eKB9awstUWFTcAfQI6e3hfidMIgGCOsSxIbmSmrGxHyUKRySVGuF+m5BTiKUVMvMqJn5Wv2AihaLO7wsW7vlFWKVTegHIzU=
Message-ID: <47D5EF16.8080509@gmail.com>
Date: Tue, 11 Mar 2008 11:31:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on
 pata_ali
References: <200803082246.47987.rjw@sisk.pl> <47D4E78A.10507@gmail.com> <47D523A1.7070808@gmail.com> <200803102236.30790.rjw@sisk.pl>
In-Reply-To: <200803102236.30790.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 10 of March 2008, Tejun Heo wrote:
>> Tejun Heo wrote:
>>> Tejun Heo wrote:
>>>> Rafael J. Wysocki wrote:
>>>>>>> where ata1 is:
>>>>>>>
>>>>>>> scsi0 : pata_ali
>>>>>>> scsi1 : pata_ali
>>>>>> Oh, is it only with audio CDs? I am unable to use DVD on pata_ali in DMA at
>>>>>> all. Have you tried to disable ATAPI DMA (libata.dma=1)?
>>>>> Data CDs seem to work fine here.
>>>> * Does booting into runlevel 1, putting in an audio cd and running
>>>> cdparanoia give the same result?
>>>>
>>>> * Does setting module parameter libata.force to "1.00:pio4" make any
>>>> difference?
>>> Oh, never mind.  I have a hunch.  I'll report back in a while.
>>>
>> Does the attached patch fix the problem?
> 
> Yes, it does.  Please push upstream.

Thanks for testing.  Will do.


-- 
tejun
