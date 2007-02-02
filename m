Return-Path: <linux-kernel-owner+w=401wt.eu-S1423029AbXBBAZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423029AbXBBAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423030AbXBBAZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:25:27 -0500
Received: from patroclus.tjworld.net ([84.12.34.246]:62422 "EHLO phwoarrr.tv"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423029AbXBBAZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:25:26 -0500
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by
	probe of partitions
From: TJ <linux@tjworld.net>
To: "Eric D. Mudama" <edmudama@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <311601c90702011610t1cb75d67if3c40347f373d7ad@mail.gmail.com>
References: <1170287439.13764.24.camel@butch.lan.tjworld.net>
	 <20070201142648.7d16e4b6.akpm@osdl.org>
	 <1170373838.30201.45.camel@butch.lan.tjworld.net>
	 <311601c90702011610t1cb75d67if3c40347f373d7ad@mail.gmail.com>
Content-Type: text/plain
Organization: TJworld
Date: Fri, 02 Feb 2007 00:25:11 +0000
Message-Id: <1170375911.30201.50.camel@butch.lan.tjworld.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-Server: High Performance Mail Server - http://surgemail.com r=-2006397171
X-Authenticated-User: tj@tjworld.net 
X-DNS-Paranoid: DNS lookup didn't match (84.12.34.243)->(dns2.hornytunes.com)->()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 17:10 -0700, Eric D. Mudama wrote:

> In the log you posted, the drive posted 51/04 to your out-of-bounds
> request, but these are 59/04, do they span the end of the device or
> something?

As you can see in the error-log including in the Ubuntu bug report, the
51/04 errors are generated in dma_intr() and occur in the initial phase
when the driver is using DMA.

After a  few of these errors it disables DMA and switches to PIO mode,
which is when the 59/04 errors are generated in task_in_intr().

TJ.

