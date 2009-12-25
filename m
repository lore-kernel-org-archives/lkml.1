Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZLYFOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZLYFOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 00:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZLYFOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 00:14:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47367 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZLYFOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 00:14:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: 2.6.28.10 - kernel BUG at mm/rmap.c:725
Cc: kosaki.motohiro@jp.fujitsu.com, CoolCold <coolthecold@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hugh.dickins@tiscali.co.uk
In-Reply-To: <2375c9f90912242056h29f20dc5rb3f891c732e0d362@mail.gmail.com>
References: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com> <2375c9f90912242056h29f20dc5rb3f891c732e0d362@mail.gmail.com>
Message-Id: <20091225135840.AA81.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Dec 2009 14:14:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Dec 24, 2009 at 7:09 PM, CoolCold <coolthecold@gmail.com> wrote:
> > 3 days ago LA on server become very high and it was working very
> > strange, so was rebooted. There are such entryies in log about kernel
> > bug - kernel BUG at mm/rmap.c:725! . Googling didn't provide me with
> > exact answer is it bug or hardware problems, something similar was
> > here https://bugs.launchpad.net/ubuntu/+source/linux/+bug/252977/comments/56
> > In general this server had number of unexpected stalls during several
> > months, but there is no ipkvm, so i can't say where something on
> > console or not. Hope you will help.
> >
> > Kernel version is 2.6.28.10 , self-builded. System - Debian stable/testing.
> >
> > Please reply to me directly, cuz i'm not subsribed to list.
> >
> > Dec 21 22:05:01 gamma kernel: Eeek! page_mapcount(page) went negative! (-1)
> > Dec 21 22:05:01 gamma kernel:   page pfn = 1f2c81
> > Dec 21 22:05:01 gamma kernel:   page->flags = 20000000008007c

PG_referenced | PG_uptodate | PG_dirty | PG_lru | PG_active | PG_swapbacked

> > Dec 21 22:05:01 gamma kernel:   page->count = 2
> > Dec 21 22:05:01 gamma kernel:   page->mapping = ffff8801fd870b58
> > Dec 21 22:05:01 gamma kernel:   vma->vm_ops = 0xffffffff80535020
> > Dec 21 22:05:01 gamma kernel:   vma->vm_ops->fault = shmem_fault+0x0/0x69
> > Dec 21 22:05:01 gamma kernel:   vma->vm_file->f_op->mmap = shmem_mmap+0x0/0x2e
> > Dec 21 22:05:01 gamma kernel: ------------[ cut here ]------------
> > Dec 21 22:05:01 gamma kernel: kernel BUG at mm/rmap.c:725!
> 
> Hey,
> 
> commit 3dc147414cc already removed this BUG(), not sure
> how serious this is...

Very serious. but We don't seen this bug for very long time. thus I bet
it's hardware corruption.

> 
> Adding mm people into Cc.
> 
> Thanks.



