Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYLERAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYLERAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYLERAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:00:04 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37056 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbYLERAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:00:03 -0500
Message-ID: <49395E0D.4080203@garzik.org>
Date: Fri, 05 Dec 2008 11:59:57 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alex Howells <alex@bytemark.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_svw breakage
References: <493949B0.6000701@bytemark.co.uk>
In-Reply-To: <493949B0.6000701@bytemark.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Howells wrote:
> Afternoon Gents (and Ladies),
> 
> I'm setting an interesting problem with the sata_svw driver on a fairly
> new (in terms of model) blade server from HP, a BL495c.
> 
> [    3.462135] PCI: setting IRQ 14 as level-triggered
> [    3.462142] sata_svw 0000:01:0e.0: PCI INT A -> Link[ISF0] -> GSI 14
> (level,
> low) -> IRQ 14
> [    3.465367] sata_svw 0000:01:0e.0: PCI INT A disabled
> [    3.467302] sata_svw: probe of 0000:01:0e.0 failed with error -16
> 
> Having trouble tracking down what 'error -16' might imply, any pointers
> for what the root cause may be and how to address it?

That's the EBUSY error (include/asm-generic/errno-base.h).

What kernel?  I don't see a 'probe of ... failed' message in drivers/ata 
nor drivers/pci.

	Jeff


