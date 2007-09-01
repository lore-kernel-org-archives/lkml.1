Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXIAKww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXIAKww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXIAKwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:52:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56009 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbXIAKwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:52:42 -0400
Message-ID: <46D94474.7080905@garzik.org>
Date: Sat, 01 Sep 2007 06:52:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sata_via: write errors on PATA drive connected to VT6421
References: <200708202242.07290.linux@rainbow-software.org> <20070821132731.6bf10b50@the-village.bc.nu> <200709010055.22200.linux@rainbow-software.org>
In-Reply-To: <200709010055.22200.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> Hello,
> I think that I've found and fixed the problem. There is a copy/paste bug in 
> vt6421_set_dma_mode() function which causes wrong values to be written to 
> PATA_UDMA_TIMING register.
> 
> 
> This patch fixes a copy/paste bug that breaks DMA modes on VT6421 PATA port.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

applied


