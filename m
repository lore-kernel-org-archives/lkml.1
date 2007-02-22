Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXBVVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXBVVpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXBVVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:45:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40809 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXBVVpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:45:35 -0500
Message-ID: <45DE0EF7.6050902@garzik.org>
Date: Thu, 22 Feb 2007 16:45:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Meelis Roos <mroos@linux.ee>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata-piix ACPI errors
References: <Pine.SOC.4.64.0702221525480.20840@math> <20070222150641.037f7fbe@lxorguk.ukuu.org.uk> <Pine.SOC.4.64.0702221614540.20840@math> <Pine.LNX.4.61.0702222017290.7553@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702222017290.7553@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 22 2007 17:26, Meelis Roos wrote:
>>> Not in those but again note that the cable detection is broken 
>>>
>>>> ata2.00: ATAPI, max UDMA/33
>> It shows UDMA/100 for HDD and UDMA/33 for DVD-ROM. Visual inspection 
>> confirms that this is correct - DVD-ROM has 40-pin cable and HDD has 
>> 80-pin one. So at least the result is not wrong.
> 
> But should not it do UDMA/66 then?

40-pin cable limits you to UDMA/33.

	Jeff



