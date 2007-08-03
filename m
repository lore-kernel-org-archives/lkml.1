Return-Path: <linux-kernel-owner+w=401wt.eu-S1763737AbXHCPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763737AbXHCPRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762758AbXHCPRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:17:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60456 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762471AbXHCPRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:17:05 -0400
Message-ID: <46B346EB.1040009@garzik.org>
Date: Fri, 03 Aug 2007 11:16:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mlord@pobox.com
Subject: Re: [PATCH] sata_qstor, pdc_adma, sata_sx4: convert to new EH
References: <20070724011404.GA14064@havoc.gtf.org> <46B31862.10201@gmail.com>
In-Reply-To: <46B31862.10201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> This is just a refresh of the existing libata-dev.git#new-eh patches
>> that convert all remaining old-EH drivers to new EH, against 2.6.23-rc1.
>>
>> All three conversions are completely untested.  pdc_adma and sata_qstor
>> need reviewing by someone with docs, in addition to testing.
>>
>> Even "it still works" or "this patch breaks stuff" feedback from users
>> is useful.
> 
> pdc_adma works fine.  Tested both a harddrive and a cdrom.  ATAPI check
> sense seems to work and harddrive was successfully recovered from
> timeout induced by shaking the harddisk for 30s.  :-)

Thanks!  I'll push pdc_adma new-EH conversion into #upstream.

	Jeff



