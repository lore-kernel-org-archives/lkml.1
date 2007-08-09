Return-Path: <linux-kernel-owner+w=401wt.eu-S938384AbXHICYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938384AbXHICYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbXHICYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:24:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54577 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277AbXHICYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:24:16 -0400
Message-ID: <46BA7ACB.20706@garzik.org>
Date: Wed, 08 Aug 2007 22:24:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ross Fawcett <claymen@parkingdenied.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil24 problems
References: <46BA6E79.8090706@parkingdenied.com>
In-Reply-To: <46BA6E79.8090706@parkingdenied.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Fawcett wrote:
> The errors I get are like these.
> 
> [ 1073.018375] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
> [ 1073.018382] ata4.00: (irq_stat 0x00020002, device error via SDB FIS)
> [ 1073.018389] ata4.00: cmd 60/80:00:80:6f:b6/00:00:04:00:00/40 tag 0
> cdb 0x0 data 65536 in
> [ 1073.018391]          res 41/40:00:f3:6f:b6/00:00:04:00:00/40 Emask
> 0x9 (media error)


Your device is signalling a media error.  That's hardware going 
ker-flop, with the controller happily reporting that fact back to us.

	Jeff


