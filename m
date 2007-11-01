Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXKAVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXKAVCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbXKAVCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:02:02 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48427 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbXKAVCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:02:00 -0400
Message-ID: <472A3EBF.1080403@garzik.org>
Date: Thu, 01 Nov 2007 17:01:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Amit Shah <shahamit@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata_nv: ata2 errors
References: <877aabc40710250048m41675163x81671097f44bba7f@mail.gmail.com> <20071101133102.1121bc28.akpm@linux-foundation.org>
In-Reply-To: <20071101133102.1121bc28.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 25 Oct 2007 13:18:50 +0530
> "Amit Shah" <shahamit@gmail.com> wrote:
> 
>> On 2.6.24-rc1 (AMD Opteron 1216), my sata_nv driver produces this
>> output on bootup:
>>
>> ata2: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
>> ata2: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
>> ata2: ATA_REG 0x40 ERR_REG 0x0
>> ata2: tag : dhfis dmafis sdbfis sacitve
>> ata2: tag 0x0: 0 1 0 0
>> ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>> ...
>> ata2.00: status: { DRDY }
>>
> 
> Are any other problems observeable?


2.6.24-rc1 is missing the fix for this that is upstream,
360737a982b1ae09e1659e0bb27085c03f02f404

	Jeff


