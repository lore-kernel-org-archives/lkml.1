Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbZDQKmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbZDQKmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbZDQKlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:41:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51180 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760724AbZDQKlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:41:51 -0400
Message-ID: <49E85CE9.4090306@pobox.com>
Date: Fri, 17 Apr 2009 06:41:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Zhenwen Xu <helight.xu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] v3 fix error on drivers/ata/pata_legacy.c
References: <20090417073259.GA6366@helight> <20090417112713.04ed51d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090417112713.04ed51d7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 17 Apr 2009 15:32:59 +0800
> Zhenwen Xu <helight.xu@gmail.com> wrote:
> 
>> fix those errors:
>>
>> drivers/ata/pata_legacy.c: In function ‘pdc_data_xfer_vlb’:
>> drivers/ata/pata_legacy.c:289: error: ‘ap’ undeclared (first use in this function)
>> drivers/ata/pata_legacy.c:289: error: (Each undeclared identifier is reported only once
>> drivers/ata/pata_legacy.c:289: error: for each function it appears in.)
>> drivers/ata/pata_legacy.c: At top level:
>> drivers/ata/pata_legacy.c:869: error: ‘ATA_PFLAG_PIO32_CHANGE’ undeclared here (not in a
>> +function)
>> make[2]: *** [drivers/ata/pata_legacy.o] Error 1
>> make[1]: *** [drivers/ata] Error 2
> 
> Looks good to me. I shall have to find something larger than PROPOSED in
> the patch title to stop Jeff applying things that were discussion code

It had a 'signed-off-by', which I took to mean, it was a proposed patch 
that was OK to merge once people were happy...  Sorry about that 
misinterpretation.

	Jeff




