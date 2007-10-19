Return-Path: <linux-kernel-owner+w=401wt.eu-S1765672AbXJSDXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765672AbXJSDXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXJSDX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:23:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:48392 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbXJSDX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fQk/KAHbay+aE6WMaQZapYsyk2sOdG2W2ri21rqWhmsYMgIRD0+herAKOuybjcsAhgYn79kiDa2OmweudiJXHtE9RBC2mTG4N2rYYIc7KiRm9ZeXU0EFrnCx+LJLYqANdQS2nzdvoH6NeoZ9/Vcgvs01NWBpuLCSlIscI3nW0mM=
Message-ID: <47182323.10706@gmail.com>
Date: Fri, 19 Oct 2007 12:23:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Paul Rolland <rol@as2917.net>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by
 libata
References: <20070826203513.4fa35f68@tux.DEF.witbe.net> <6bffcb0e0708261637s3369dd6fl1f833461e41c4daa@mail.gmail.com>
In-Reply-To: <6bffcb0e0708261637s3369dd6fl1f833461e41c4daa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 26/08/07, Paul Rolland <rol@as2917.net> wrote:
>> My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
>> reporting a :
>> irq 23: nobody cared (try booting with the "irqpoll" option)
>> together with a Call Trace, but :
>>  - irqpoll is present on the command line,
>>  - the irq is reported to be used by libata,
>>  - the irqpoll option is mandatory if I want _some_ of my SATA disks to be
>>    accessible.
>>
>> I've attached a file with :
>>  - dmesg,
>>  - cat /proc/interrupts
>>  - lspci
>>  - lspci -vvv
>>  - my .config
>>
>> I've tried mounting and accessing all the disks, and it works.
>> The last weird thing : though reported as used by libata, the irq 23 counter
>> seems to be fixed at 200001, though I've mounted and accessed all the
>> disks !

Does this still happen with 2.6.23?  If so, please post boot log.  Thanks.

-- 
tejun
