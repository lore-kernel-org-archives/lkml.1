Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbXKOEHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbXKOEHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbXKOEHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:07:34 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22275 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbXKOEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:07:32 -0500
Date: Wed, 14 Nov 2007 22:06:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2/2] sata_nv: fix ATAPI issues with memory over 4GB (v3)
In-reply-to: <473BA332.9030406@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Message-id: <473BC5DF.1040302@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <473A7677.6080007@shaw.ca> <473BA332.9030406@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert Hancock wrote:
>> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
>> on systems with memory located above 4GB. We need to delay setting the 64-bit
>> DMA mask until the PRD table and padding buffer are allocated so that they don't
>> get allocated above 4GB and break legacy mode (which is needed for ATAPI
>> devices).
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> applied to #tj-upstream-fixes.
> 

I have a report that these patches crashed but the previous patch worked:

https://bugzilla.redhat.com/show_bug.cgi?id=351451

So there may still be a problem here.
