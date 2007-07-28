Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbXG1SNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbXG1SNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXG1SNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:13:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36731 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXG1SNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:13:10 -0400
Message-ID: <46AB8732.6080109@garzik.org>
Date: Sat, 28 Jul 2007 14:13:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
CC: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] fix IDE legacy mode resource
References: <20070728220420.352c316b.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20070728220420.352c316b.yoichi_yuasa@tripeaks.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoichi Yuasa wrote:
> Hi,
> 
> I got the following error on MIPS Cobalt.
> MIPS Cobalt has the 0x10000000 offset between resource and bus region. 
> 
> PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> pata_via 0000:00:09.1: failed to request/iomap BARs for port 0 (errno=-16)
> PCI: Unable to reserve I/O region #3:8@f0000170 for device 0000:00:09.1
> pata_via 0000:00:09.1: failed to request/iomap BARs for port 1 (errno=-16)
> pata_via 0000:00:09.1: no available native port
> 
> At this point, these resources should be the bus regions.
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

I'm not sure I understand what's going on here... could you or someone 
provide additional explanation as to why this is a fix?

Thanks,

	Jeff



