Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbXIZOdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbXIZOdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXIZOdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:33:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50886 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbXIZOde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:33:34 -0400
Message-ID: <46FA6DB8.70508@garzik.org>
Date: Wed, 26 Sep 2007 10:33:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peer Chen <peerchen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
References: <200709211327569648280@gmail.com>	<46F9DA07.4080201@garzik.org>	<20070926122332.39351382@the-village.bc.nu>	<46FA4587.4070105@garzik.org> <20070926153028.6fc5b2ce@the-village.bc.nu>
In-Reply-To: <20070926153028.6fc5b2ce@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> NAK - mmio is an iomap so writel and readl are the wrong things to use
>> The patch is consistent with the rest of the driver.
>> You are welcome to submit a patch to convert ahci to using ioremap.
> 
> You could just flip the relevant function to use ioread while you are
> tidying it up, instead of spreading new bugs into the code.

No, as I just noted above, the proper fix for this driver is to use 
ioremap rather than pci_iomap.

Adding support to ahci for legacy PIO is completely pointless.

	Jeff



