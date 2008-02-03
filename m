Return-Path: <linux-kernel-owner+w=401wt.eu-S935490AbYBCBhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490AbYBCBhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbYBCBhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:37:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42753 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbYBCBha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:37:30 -0500
Message-ID: <47A51AD7.3070102@garzik.org>
Date: Sat, 02 Feb 2008 20:37:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
References: <745427.71265.qm@web52907.mail.re2.yahoo.com>
In-Reply-To: <745427.71265.qm@web52907.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rankin wrote:
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for UDMA/66
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link


Had at least one other report like this...  Sleepiness prevents me from 
recalling more at the moment, but I think the other report was fixed 
with a special ACPI switch...

/me puts in pile for Monday...

	Jeff


