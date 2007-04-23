Return-Path: <linux-kernel-owner+w=401wt.eu-S1161161AbXDWF3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161AbXDWF3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161194AbXDWF3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:29:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55466 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161161AbXDWF3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:29:13 -0400
Message-ID: <462C441F.1070506@garzik.org>
Date: Mon, 23 Apr 2007 01:29:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: alex=lists-linux-kernel@yuriev.com
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA errors/messages after upgrade to 2.6.20.7
References: <20070423035622.GB10106@s2.yuriev.com>
In-Reply-To: <20070423035622.GB10106@s2.yuriev.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alex=lists-linux-kernel@yuriev.com wrote:
> 
> It is a Samsung HD501LJ SATA drive connected to 631xESB/632xESB controller.
> Reading and writing every block of the drive does not generate any other
> errors/failures. This is observed in 2.6.20.7 like a clockwork on any
> badblocks -v run or rebuild of a MD raid1 array onto the disk. 
> 
> It, however, was not observed on 2.6.18 in 182 badblocks -v runs followed by
> rebuild of MD raid1 array.
> 
> Any idea what it might be?
> 
> Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
> Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
> Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
> Apr 23 14:45:34 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)

Does 'smartctl -d ata -t long /dev/XXXXX' return errors?

Media error is typically just that...

	Jeff



