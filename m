Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbXI3P75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbXI3P75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbXI3P7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:59:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38428 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893AbXI3P7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:59:48 -0400
Message-ID: <46FFC7F1.6080409@garzik.org>
Date: Sun, 30 Sep 2007 11:59:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>	<20070930152908.1f58d39d@the-village.bc.nu>	<20070930164610.20818867@localhost>	<46FFBB2D.6060004@garzik.org>	<20070930172859.7fd44eab@localhost>	<46FFC42A.9080300@garzik.org> <20070930175207.5bfa89a8@localhost>
In-Reply-To: <20070930175207.5bfa89a8@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> On Sun, 30 Sep 2007 11:43:38 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>>> it isn't supported here:
>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA  
>> Did you actually try my suggestion?
> 
> Yes ("libata.fua=1" is ok I think, or it should just be "libata.fua"?):
> ...
> [    0.000000] Kernel command line: root=/dev/sda6 ro vga=0x305 libata.fua=1
> ...
> [  285.004166] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
> ...

Is libata built into the kernel, or a module?

If it is a module, using the kernel command line won't work.

	Jeff



