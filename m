Return-Path: <linux-kernel-owner+w=401wt.eu-S1751156AbXCQQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbXCQQKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 12:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXCQQKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 12:10:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39533 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbXCQQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 12:10:16 -0400
Message-ID: <45FC12E4.6010204@garzik.org>
Date: Sat, 17 Mar 2007 12:10:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [BUG]  PATA_PCMCIA  cmd port
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>	<20061217040222.GD17561@ftp.linux.org.uk>	<20070211101537.e40fa309.komurojun-mbn@nifty.com> <20070317220050.380d9f51.komurojun-mbn@nifty.com>
In-Reply-To: <20070317220050.380d9f51.komurojun-mbn@nifty.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Komuro wrote:
> The pata_pcmcia driver reports the cmd port is 0x00010100,
> but actually the cmd port is 0x0100.
> 
> Is this corect?
> 
>> ata1: PATA max PIO0 cmd 0x00010100 ctl 0x0001010e bmdma 0x00000000 irq 3
>                                ^^^^^^^^^^^^^      ^^^^^^^^^^^^^

It's printing out the post-iomap numbers.  Just a cosmetic problem. 
Patches welcome though :)

	Jeff


