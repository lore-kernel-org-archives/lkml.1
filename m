Return-Path: <linux-kernel-owner+w=401wt.eu-S1761116AbYHEMCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761116AbYHEMCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbYHEMBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:01:54 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39206 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759010AbYHEMBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:01:54 -0400
Date: Tue, 05 Aug 2008 21:01:50 +0900 (JST)
Message-Id: <20080805.210150.91309965.taka@valinux.co.jp>
To: s-uchida@ap.jp.nec.com
Cc: righi.andrea@gmail.com, ryov@valinux.co.jp, ngupta@google.com,
       vtaras@openvz.org, dave@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: Too many I/O controller patches
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
References: <1217870433.20260.101.camel@nimitz>
	<489748E6.5080106@gmail.com>
	<000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I think that OOM problems caused by memory/cache systems.
> So, it will be better that I/O controller created out of these problems
> first, although a lateness of the I/O device would be related.
> If these problem can be resolved, its technique should be applied into 
> normal I/O control as well as cgroups.

Yes, this is one of the problems linux kernel still has, which should
be solved.

But I believe this should be done in the linux memory management layer
including the cgroup memory controller, which has to work correctly
on any type of device with various access speeds.

I think it's better that I/O controllers should only focus on flow of
I/O requests. This approach will keep the implementation of linux
kernel simple.

> Buffered write I/O is also related with cache system.
> We must consider this problem as I/O control.
> I don't have a good way which can resolve this problems.
> 

Thank you,
Hirokazu Takahashi.

