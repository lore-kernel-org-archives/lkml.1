Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXKOEMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXKOEMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbXKOELy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:11:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:63248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbXKOELw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:11:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BnbMQUngwWi8D2x6dOQDjSf8v5JJUN9VzOH3TZxqckcZ64DTaroiBWOVhpX/dAc1iDIhwLUypQiqRBd84SAFn52n2D10svqK+GkBajLJiAK2ZS+1ahHiAXl+auPW0Gzs2eukBY6mcTIYqTX7V8TFMETwL5+18FH2VZSc0cy1PgI=
Message-ID: <473BC6FE.8090700@gmail.com>
Date: Thu, 15 Nov 2007 13:11:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/2] sata_nv: fix ATAPI issues with memory over 4GB (v3)
References: <473A7677.6080007@shaw.ca> <473BA332.9030406@gmail.com> <473BC5DF.1040302@shaw.ca>
In-Reply-To: <473BC5DF.1040302@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> Robert Hancock wrote:
>>> This fixes some problems with ATAPI devices on nForce4 controllers in
>>> ADMA mode
>>> on systems with memory located above 4GB. We need to delay setting
>>> the 64-bit
>>> DMA mask until the PRD table and padding buffer are allocated so that
>>> they don't
>>> get allocated above 4GB and break legacy mode (which is needed for ATAPI
>>> devices).
>>>
>>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>>
>> applied to #tj-upstream-fixes.
>>
> 
> I have a report that these patches crashed but the previous patch worked:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=351451
> 
> So there may still be a problem here.

Hmmm... The change seemed safe to me.  Anyways, dropping the patch for
now.  Please re-send later.  Also, please format patch description such
that it fits in 80c.

Thanks.

-- 
tejun
