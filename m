Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXFNQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXFNQWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbXFNQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:21:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47079 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXFNQVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:21:51 -0400
Message-ID: <46716B1D.1070902@garzik.org>
Date: Thu, 14 Jun 2007 12:21:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Nigel Kukard <nkukard@lbsd.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <4671366B.7090702@lbsd.net>
In-Reply-To: <4671366B.7090702@lbsd.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Kukard wrote:
> I'm stumped trying to track down the below intermittent problem.....
> 
> I've confirmed this problem on 2.6.19, 2.6.20 and 2.6.21.
> 
> Any help greatly appreciated!
> 
> Regards
> Nigel
> 
> 
> Jun 14 07:55:52 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> Jun 14 07:55:52 nigel-m2v kernel: ata2.00: cmd
> ca/00:18:87:e7:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 12288 out
> Jun 14 07:55:52 nigel-m2v kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jun 14 07:55:52 nigel-m2v kernel: ata2: soft resetting port
> Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
> 0x0001c807
> Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
> 0x0001c807
> Jun 14 07:56:22 nigel-m2v kernel: ata2.00: qc timeout (cmd 0xef)
> Jun 14 07:56:22 nigel-m2v kernel: ata2.00: failed to set xfermode
> (err_mask=0x4)

Try 2.6.22-rc4-gitX...

	Jeff



