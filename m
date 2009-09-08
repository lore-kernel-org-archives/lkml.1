Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZIHFFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZIHFFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 01:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZIHFFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 01:05:15 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:50736 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZIHFFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 01:05:14 -0400
Date: Tue, 08 Sep 2009 14:05:16 +0900 (JST)
Message-Id: <20090908.140516.104049366.ryov@valinux.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: riel@redhat.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090908032254.GJ8315@balbir.in.ibm.com>
References: <4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908032254.GJ8315@balbir.in.ibm.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-08 12:01:19]:
> 
> > I think there are some advantages to dm-ioband. That's why I post
> > dm-ioband to the mailing list.
> > 
> > - dm-ioband supports not only proportional weight policy but also rate
> >   limiting policy. Besides, new policies can be added to dm-ioband if
> >   a user wants to control bandwidth by his or her own policy.
> > - The dm-ioband driver can be replaced without stopping the system by
> >   using device-mapper's facility. It's easy to maintain.
> > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> >   advantage.)
> 
> But don't you need page_cgroup for IO tracking?

It is not necessary when controlling bandwidth on a per partition
basis or on a IO thread basis like Xen blkback kernel thread.

Here are configration examples.
http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband/man/examples

Thanks,
Ryo Tsuruta
