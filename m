Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbZBECIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbZBECIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZBECHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:07:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885AbZBECHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:07:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Date: Thu, 5 Feb 2009 03:07:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Norbert Preining <preining@logic.at>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902050307.04955.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Linus Torvalds wrote:
> 
> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12599
> > Subject		: dri /dev node disappeared with 2.6.29-rc1
> > Submitter	: Norbert Preining <preining@logic.at>
> > Date		: 2009-01-15 13:42 (21 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123202701026647&w=4
> 
> I think this one is simply that Intel DRI now requires CONFIG_FB.
> 
> So make sure that you say yes to the CONFIG_FB question (easiest fix: just 
> edit the .config file and change the line "# CONFIG_FB is not set" to 
> "CONFIG_FB=y" and do "make oldconfig" - I realize that people think that 
> graphical config front-ends are simpler, but often just editing the file 
> is the quickest way).

Well, I always have doubts whether to list such things or not and I usually
end up deciding that listing is probably better than not listing.

I think I'll close this one, it's got enough attention IMO.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12591
> > Subject		: NULL pointer dereference in blk_queue_io_stat
> > Submitter	: Petr Vandrovec <vandrove@vc.cvut.cz>
> > Date		: 2009-01-31 23:58 (5 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bc58ba9468d94d62c56ab9b47173583ec140b165
> > Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> 
> I think this one is fixed by commit fb8ec18c316d8.

Closed.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12511
> > Subject		: WARNING: at drivers/dma/dmaengine.c:352
> > Submitter	: Ingo Molnar <mingo@elte.hu>
> > Date		: 2009-01-19 21:31 (17 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123240070614443&w=4
> > Handled-By	: Dan Williams <dan.j.williams@intel.com>
> 
> This warning just got removed as bogus.
> 
> Commit 83436a0560e9ef8af2f0796264dde4bed1415359

Closed.
 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12506
> > Subject		: Undefined symbols when CONFIG_MFD_PCF50633 is enabled
> > Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
> > Date		: 2009-01-17 10:56 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123218991104592&w=4
> 
> Commit 9e6f8ed7c3a303d37eb119847dd3029701e37e28

Closed.

Thanks,
Rafael
