Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbXFLAJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbXFLAJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXFLAJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:09:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49847 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXFLAJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:09:30 -0400
Message-ID: <466DE438.70108@garzik.org>
Date: Mon, 11 Jun 2007 20:09:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: libata passthru: support PIO multi commands
References: <200706112200.l5BM0qFn005767@hera.kernel.org> <20070611233917.4bd8c6d7@the-village.bc.nu>
In-Reply-To: <20070611233917.4bd8c6d7@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> +	if (is_multi_taskfile(tf)) {
>> +		unsigned int multi_count = 1 << (cdb[1] >> 5);
>> +
>> +		/* compare the passed through multi_count
>> +		 * with the cached multi_count of libata
>> +		 */
>> +		if (multi_count != dev->multi_count)
>> +			ata_dev_printk(dev, KERN_WARNING,
>> +				       "invalid multi_count %u ignored\n",
>> +				       multi_count);
>> +	}
> 
> What limits log spamming here ?

Intelligence of the user with privs?


> Also shouldn't we error this
> situation not proceed and hope that enough data was supplied not
> to leave us stuck half way through a command having made a nasty
> mess on disk ?

Is that English?  Can you be more specific and more clear?

	Jeff


