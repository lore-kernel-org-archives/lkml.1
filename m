Return-Path: <linux-kernel-owner+w=401wt.eu-S965531AbXA3OuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531AbXA3OuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965532AbXA3OuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:50:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46430 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965531AbXA3OuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:50:18 -0500
Message-ID: <45BF5B1E.6050909@garzik.org>
Date: Tue, 30 Jan 2007 09:50:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Jean Delvare <jdelvare@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
References: <45B6A94A.3010006@yahoo.com.au>	<200701291600.32580.jdelvare@suse.de>	<45BEAEE3.9080003@yahoo.com.au>	<200701300854.06083.jdelvare@suse.de> <20070130145629.7e40deac@localhost.localdomain>
In-Reply-To: <20070130145629.7e40deac@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> You have an old VT82C686 south bridge, which was tagged as "special" by
>> Alan. For this chip, Alan's code only allows devices 00:00.x to be quirked.
>> As my code was merely a reimplementation of Alan's idea, it does the same.
>> Your USB controllers are at 00:07.x, so I'm not surprised they weren't
>> quirked.
>>
>> Alan, why were dev_lo and dev_hi both set to 0 for the VT82C868 in your
>> implementation? Is it a typo, or...?
> 
> According to the documentation the VT82C686 has the following devices on
> the internal bus: bus 0 dev ? fn 0-6.  dev ? being the device of the
> bridge itself. Re-reading the docs unlike the other the PCI idents aren't
> fixed so my assumption of dev 0 is actually unsafe. I can't see anything
> in the doc which guarantees 7 either.


BTW, older VIA docs are publicly archived at 
http://gkernel.sourceforge.net/specs/via/

	Jeff



