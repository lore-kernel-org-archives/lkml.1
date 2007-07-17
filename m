Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbXGQEAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbXGQEAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXGQEA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:00:29 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:34168 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXGQEA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:00:28 -0400
To: satyam.sharma@gmail.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070717095703X.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 17 Jul 2007 09:57:03 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 06:22:25 +0530

> On 7/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> 
> CONFIG_BLK_DEV_BSG=y
> CONFIG_SCSI=m
> 
> block/built-in.o: In function `bsg_init':
> block/bsg.c:1097: undefined reference to `scsi_register_interface'
> make: *** [.tmp_vmlinux1] Error 1

This should be fixed by the following commit (thanks !):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29417b899a77aaba1c060f5e123db4f50006f58a
