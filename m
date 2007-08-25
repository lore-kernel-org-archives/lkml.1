Return-Path: <linux-kernel-owner+w=401wt.eu-S933806AbXHYI4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbXHYI4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765089AbXHYI40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:56:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53461 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764603AbXHYI4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:56:25 -0400
Message-ID: <46CFEEB3.6000802@pobox.com>
Date: Sat, 25 Aug 2007 04:56:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: readXs on pci*iomap-ped regions [Was: [PATCH] /drivers/char sx.c
 ioremap -> pci_ioremap api]
References: <46CF2849.2090008@gmail.com> <4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com> <20070824201530.5d741b37@the-village.bc.nu>	<46CF399E.3010808@gmail.com> <20070824213439.0007e653@the-village.bc.nu> <46CFEC40.7060006@gmail.com>
In-Reply-To: <46CFEC40.7060006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the driver knows its MMIO, using readX/writeX after pci_iomap() is 
just fine, for all current implementations, and it makes sense that way.

	Jeff



