Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZDNCuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZDNCuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZDNCuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:50:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43531 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZDNCuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:50:00 -0400
Date: Mon, 13 Apr 2009 22:49:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm-ioband: Test results.
Message-ID: <20090414024943.GA976@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp> <20090413144626.GF18007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413144626.GF18007@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:46:26AM -0400, Vivek Goyal wrote:
> On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> > Hi Alasdair and all,
> > 
> > I did more tests on dm-ioband and I've posted the test items and
> > results on my website. The results are very good.
> > http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> > 
> 
> Hi Ryo,
> 
> I quickly looked at the xls sheet. Most of the test cases seem to be
> direct IO. Have you done testing with buffered writes/async writes and
> been able to provide service differentiation between cgroups?
> 
> For example, two "dd" threads running in two cgroups doing writes.
> 

Just realized that last time I replied to wrong mail id. Ryo, this time
you should get the mail. This is reply to my original reply.

Also I wanted to test run your patches. How do I do that? I see that your
patches are based on dm quilt tree. I downloaded the dm-patches and tried
to apply on top of 2.6.30-rc1 but it failed. So can't apply your patches
now.

So what's the simplest way of testing your changes on latest kernels?

Thanks
Vivek

Applying patch dm-add-request-based-facility.patch
patching file drivers/md/dm-table.c
Hunk #1 succeeded at 1021 (offset 29 lines).
patching file drivers/md/dm.c
Hunk #1 succeeded at 90 (offset 6 lines).
Hunk #2 succeeded at 175 (offset -1 lines).
Hunk #3 succeeded at 427 (offset 6 lines).
Hunk #4 succeeded at 648 (offset 10 lines).
Hunk #5 succeeded at 1246 with fuzz 2 (offset 20 lines).
Hunk #6 succeeded at 1273 (offset 3 lines).
Hunk #7 succeeded at 1615 with fuzz 1 (offset 20 lines).
Hunk #8 succeeded at 2016 with fuzz 1 (offset 14 lines).
Hunk #9 succeeded at 2141 (offset 33 lines).
Hunk #10 FAILED at 2321.
Hunk #11 FAILED at 2336.
Hunk #12 succeeded at 2388 with fuzz 2 (offset 29 lines).
2 out of 12 hunks FAILED -- rejects in file drivers/md/dm.c
patching file drivers/md/dm.h
patching file include/linux/device-mapper.h
Hunk #1 succeeded at 230 (offset -1 lines).
Patch dm-add-request-based-facility.patch does not apply (enforce with -f)

> Thanks
> Vivek
