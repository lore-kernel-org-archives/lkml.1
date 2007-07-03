Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbXGCPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbXGCPkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXGCPj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:39:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33069 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbXGCPj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:39:58 -0400
Message-ID: <468A6DCA.9070205@garzik.org>
Date: Tue, 03 Jul 2007 11:39:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_pcmcia: Switch to ata_sff_port_start
References: <20070703151405.4ffb1ece@the-village.bc.nu>
In-Reply-To: <20070703151405.4ffb1ece@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> PCMCIA doesn't use DMA and as this driver is used on many platforms we
> don't want it to fail on those that define the DMA alloc API as a NULL
> return
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


