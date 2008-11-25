Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYKYCbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYKYCbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 21:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYKYCbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 21:31:31 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60747 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752471AbYKYCba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 21:31:30 -0500
Date: Tue, 25 Nov 2008 11:33:59 +0900 (JST)
Message-Id: <20081125.113359.623571555980951312.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       fchecconi@gmail.com, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20081120134701.GB29306@redhat.com>
References: <20081113221304.GH7542@redhat.com>
	<20081120.182053.220301508585579959.ryov@valinux.co.jp>
	<20081120134701.GB29306@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> > > Ryo, do you still want to stick to two level scheduling? Given the problem
> > > of it breaking down underlying scheduler's assumptions, probably it makes
> > > more sense to the IO control at each individual IO scheduler.
> > 
> > I don't want to stick to it. I'm considering implementing dm-ioband's
> > algorithm into the block I/O layer experimentally.
> 
> Thanks Ryo. Implementing a control at block layer sounds like another
> 2 level scheduling. We will still have the issue of breaking underlying
> CFQ and other schedulers. How to plan to resolve that conflict.

I think there is no conflict against I/O schedulers.
Could you expain to me about the conflict?

> What do you think about the solution at IO scheduler level (like BFQ) or
> may be little above that where one can try some code sharing among IO
> schedulers? 

I would like to support any type of block device even if I/Os issued
to the underlying device doesn't go through IO scheduler. Dm-ioband
can be made use of for the devices such as loop device.

Thanks,
Ryo Tsuruta
