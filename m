Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZIDBMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZIDBMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZIDBMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:12:21 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:36675 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbZIDBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:12:21 -0400
Date: Fri, 04 Sep 2009 10:12:22 +0900 (JST)
Message-Id: <20090904.101222.226781140.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090903131146.GA12041@redhat.com>
References: <20090901165011.GB3753@redhat.com>
	<20090901174724.GC3753@redhat.com>
	<20090903131146.GA12041@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Sep 01, 2009 at 01:47:24PM -0400, Vivek Goyal wrote:
> > On Tue, Sep 01, 2009 at 12:50:11PM -0400, Vivek Goyal wrote:
> > > Hi Ryo,
> > > 
> > > I decided to play a bit more with dm-ioband and started doing some
> > > testing. I am doing a simple two dd threads doing reads and don't seem
> > > to be gettting the fairness. So thought will ask you what's the issue
> > > here. Is there an issue with my testing procedure.
> > > 
> > > I got one 40G SATA drive (no hardware queuing). I have created two
> > > partitions on that disk /dev/sdd1 and /dev/sdd2 and created two ioband
> > > devices ioband1 and ioband2 on partitions sdd1 and sdd2 respectively. The
> > > weights of ioband1 and ioband2 devices are 200 and 100 respectively. 
> > > 
> > > I am assuming that this setup will create two default groups and IO
> > > going to partition sdd1 should get double the BW of partition sdd2.
> > > 
> > > But it looks like I am not gettting that behavior. Following is the output
> > > of "dmsetup table" command. This snapshot has been taken every 2 seconds
> > > while IO was going on. Column 9 seems to be containing how many sectors
> > > of IO has been done on a particular io band device and group. Looking at
> > > the snapshot, it does not look like that ioband1 default group got double
> > > the BW of ioband2 default group.  
> > > 
> > > Am I doing something wrong here?
> > > 
> > 
> 
> Hi Ryo,
> 
> Did you get a chance to look into it? Am I doing something wrong or it is
> an issue with dm-ioband.

Sorry, I missed it. I'll look into it and report back to you.

Thanks,
Ryo Tsuruta
