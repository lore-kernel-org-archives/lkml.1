Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbXJZAm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbXJZAm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXJZAmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:42:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43296 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbXJZAmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:42:20 -0400
Message-ID: <472137E8.9020109@garzik.org>
Date: Thu, 25 Oct 2007 20:42:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ide: fix drive_is_ready() for non-PCI hosts and CONFIG_IDEPCI_SHARE_IRQ=y
References: <200710260136.37333.bzolnier@gmail.com> <20071026010515.260672b4@the-village.bc.nu>
In-Reply-To: <20071026010515.260672b4@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 26 Oct 2007 01:36:37 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
>> Need to check if the host is a PCI one before reading IDE_ALTSTATUS_REG.
>>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Umm why ? The altstatus register goes back to ST-506 and the original IBM
> XT hard disk controller card ?

I'm pretty sure there are at least a few controllers out there where the 
AltStatus/Control register block is simply non-existent.

	Jeff



