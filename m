Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbYBJN7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbYBJN7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYBJN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:59:11 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46695 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYBJN7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:59:09 -0500
Date: Sun, 10 Feb 2008 15:59:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: scsi/arm/fas216.c compile error
Message-ID: <20080210135905.GB2436@cs181133002.pp.htv.fi>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi> <47AEF6FD.8080801@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47AEF6FD.8080801@panasas.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 03:07:09PM +0200, Boaz Harrosh wrote:
> On Sat, Feb 09 2008 at 2:04 +0200, Adrian Bunk <adrian.bunk@movial.fi> wrote:
> > Commit 30b0c37b27485a9cb897bfe3824f6f517b8c80d6 causes the following 
> > compile error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      drivers/scsi/arm/fas216.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c: In function 'fas216_std_done':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c:2120: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c:2122: error: 'struct scsi_cmnd' has no member named 'use_sg'
> > make[4]: *** [drivers/scsi/arm/fas216.o] Error 1
> > 
> > <--  snip  -->
> > 
> > cu
> > Adrian
> > 
> It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
>   [SCSI] arm: convert to accessors and !use_sg cleanup
>...

fas216.c != acornscsi.c

> Boaz

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

