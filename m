Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbYBJNxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbYBJNxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYBJNxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:53:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41523 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYBJNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:53:34 -0500
Date: Sun, 10 Feb 2008 13:52:49 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: scsi/arm/fas216.c compile error
Message-ID: <20080210135249.GA25703@flint.arm.linux.org.uk>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi> <47AEF6FD.8080801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AEF6FD.8080801@panasas.com>
User-Agent: Mutt/1.4.2.1i
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
> 
> Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
> to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
> we finally managed a Tested-by:.
> 
> I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
> schedule.

Oh, just 20 minutes in your opinion?  Reality works at a different tick
rate to your timing then.

However, if you're seeing a bulid error, it means that the *WRONG* patch
went in.  No idea why I even bothered to test it if that's what happens.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
