Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYH3KvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYH3KvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYH3KvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:51:07 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:44141 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYH3KvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:51:06 -0400
Date: Sat, 30 Aug 2008 12:49:45 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: eaa@wprmedical.com, linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: MTD/block regression (was Re: Slub debugging NAND error in
 2.6.25.10.atmel.2)
Message-ID: <20080830124945.3de989f6@siona.skinnemoen.net>
In-Reply-To: <20080830103318N.fujita.tomonori@lab.ntt.co.jp>
References: <6B5648EA2E2C2D42AF2FF7691522AD92417CA6@wpr01.wprmedical.local>
 <20080829114828.279b79bc@hskinnemo-gx745.norway.atmel.com>
 <20080829162824.17f8746b@hskinnemo-gx745.norway.atmel.com>
 <20080830103318N.fujita.tomonori@lab.ntt.co.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2008 10:49:37.0967 (UTC) FILETIME=[191C03F0:01C90A8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 10:34:12 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Really sorry about that. A fix was queued in Jens' tree:
> 
> http://marc.info/?l=linux-kernel&m=122000748432301&w=2

Ah, great. Sorry for not searching the list before posting.

> > Unfortunately, I can't revert it cleanly, so it could be a false
> > positive. But it does sort of make sense, since it makes the filter
> > per-queue instead of per-gendisk, so if MTD uses the same queue for
> > several block devices, the filter kobject might end up being
> > initialized multiple times. Or something.  
> 
> Right, the problem is that MTD uses the same queue for multiple
> gendisks. It would be great if a MTD developer could fix it.

Yeah, I sort of suspected that MTD was doing something unusual.
Unfortunately, I'm not familiar enough with the MTD and block code
to help out here...

Haavard	
