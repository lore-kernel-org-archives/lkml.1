Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXGJS5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXGJS5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXGJS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:57:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33404 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbXGJS5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:57:20 -0400
Message-ID: <4693D68C.7000303@garzik.org>
Date: Tue, 10 Jul 2007 14:57:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Deepak Saxena <dsaxena@plexity.net>, Dan Faerch <dan@hacker.dk>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ata and netdev (was Re: -mm merge plans for 2.6.23)
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<4693C4F8.40903@garzik.org> <20070710112458.e9dbb55e.akpm@linux-foundation.org>
In-Reply-To: <20070710112458.e9dbb55e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 10 Jul 2007 13:42:16 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> (just to provide my indicator of status)
> 
> Thanks.
> 
>>> libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
>> are other pata_platform people happy with this?  I don't know embedded 
>> well enough to know if adding this struct member will break things.
> 
> This is just a silly remove-unneeded-cast-of-void* cleanup.  I wrote this
> as a fixup against
> libata-add-irq_flags-to-struct-pata_platform_info.patch with the intention
> of folding it into that base patch, but you went and merged the submitter's
> original patch so this trivial fixup got stranded in -mm.  Feel free to give
> it the piss-off-too-trivial treatment.

I'm sorry, I didn't look closely enough.  I was referring to the 
add-irq-flags patch itself, not your small fix.


>>> ata-ahci-alpm-store-interrupt-value.patch
>>> ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
>>> ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
>>> ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
>>>
>>>  These appear to need some work.
>> seemed mostly OK to me.  what comments did I miss?
> 
> Oh, I thought these were the patches which affected scsi and which James
> had issues with.  I guess I got confused.

hrm.  ISTR James wanted some cleanups, Kristen did some cleanups, then 
looking at the cleanups decided they were needed / appropriate at this time.

Anyway, these are in my mbox queue and the libata portions (of which the 
code is the majority) seem OK.  Need to give them a final review.

	Jeff



