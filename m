Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbXHaKx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbXHaKx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXHaKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:53:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59505 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377AbXHaKxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:53:48 -0400
Message-ID: <46D7F337.80608@garzik.org>
Date: Fri, 31 Aug 2007 06:53:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] IOC3: Program UART predividers.
References: <20070826175122.GA16430@linux-mips.org>
In-Reply-To: <20070826175122.GA16430@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> The IOC3 driver's UART detection bits used to rely on the the firmware
> setting the UART pre-divider in a way that's apropriate for the 8250
> driver which doesn't currently program this register.  This happens
> to work for the console but not rarely for additional ports.
> 
> While at it, also program the UART to RS-232 PIO mode; it the UART might
> have been in mac-serial and/or DMA mode though that hasn't actually been
> observed in practice.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

applied


