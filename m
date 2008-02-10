Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYBJNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYBJNI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYBJNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:08:20 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:51594 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbYBJNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:08:19 -0500
Message-ID: <47AEF6FD.8080801@panasas.com>
Date: Sun, 10 Feb 2008 15:07:09 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <adrian.bunk@movial.fi>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: scsi/arm/fas216.c compile error
References: <20080209000413.GE6505@cs181133002.pp.htv.fi>
In-Reply-To: <20080209000413.GE6505@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09 2008 at 2:04 +0200, Adrian Bunk <adrian.bunk@movial.fi> wrote:
> Commit 30b0c37b27485a9cb897bfe3824f6f517b8c80d6 causes the following 
> compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/scsi/arm/fas216.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c: In function 'fas216_std_done':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c:2120: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c:2122: error: 'struct scsi_cmnd' has no member named 'use_sg'
> make[4]: *** [drivers/scsi/arm/fas216.o] Error 1
> 
> <--  snip  -->
> 
> cu
> Adrian
> 
It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
  [SCSI] arm: convert to accessors and !use_sg cleanup

Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
we finally managed a Tested-by:.

I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
schedule.

Boaz
