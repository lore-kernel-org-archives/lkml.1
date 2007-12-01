Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbXLAWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbXLAWg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 17:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXLAWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 17:36:48 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41907 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXLAWgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 17:36:47 -0500
Message-ID: <4751E1FD.60206@garzik.org>
Date: Sat, 01 Dec 2007 17:36:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [libata] Set proper ATA UDMA mode for bf548 according
 to	system clock.
References: <1196138859.6974.2.camel@eight.analog.com>
In-Reply-To: <1196138859.6974.2.camel@eight.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sonic zhang wrote:
> UDMA Mode - Frequency compatibility
> 
> UDMA5 - 100 MB/s   - SCLK  = 133 MHz
> UDMA4 - 66 MB/s    - SCLK >=  80 MHz
> UDMA3 - 44.4 MB/s  - SCLK >=  50 MHz
> UDMA2 - 33 MB/s    - SCLK >=  40 MHz
> 
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/ata/pata_bf54x.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

applied #upstream-fixes


