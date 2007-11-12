Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbXKLTLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbXKLTLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXKLTLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:11:22 -0500
Received: from rtr.ca ([76.10.145.34]:3624 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXKLTLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:11:21 -0500
Message-ID: <4738A558.1040304@rtr.ca>
Date: Mon, 12 Nov 2007 14:11:20 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ron Yorgason <yorgasor@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
References: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
In-Reply-To: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ron Yorgason wrote:
> But I'm concerned about performance.  The delkin_cb.c file states:
> 
>  *  This is slightly peculiar, in that it is a PCI driver,
>  *  but is NOT an IDE PCI driver -- the IDE layer does not directly
>  *  support hot insertion/removal of PCI interfaces, so this driver
>  *  is unable to use the IDE PCI interfaces.  Instead, it uses the
>  *  same interfaces as the ide-cs (PCMCIA) driver uses.
>  *  On the plus side, the driver is also smaller/simpler this way.
> 
> 
> My attempts to use hdparm to turn on DMA for my device have failed.  I
> assume this means DMA is not currently supported.  In my tests, read
> support seems fast enough, but writing maxes out around 2MB/s.  And if
> there is a lot of reading and writing going on (ie, trying to compile
> the kernel), performance is pretty abysmal.  What would it take to get
> proper DMA support?  Is it an architecture problem, in that this
> doesn't use the normal IDE PCI driver?  Is it a lack of documentation
> on card specs?  What can I do to help?
..

The problem is total lack of documentation.

If you can find some docs, then we can fully support it,
both in old IDE (as current), and in the newer libata (not there at all now).

Cheers 
