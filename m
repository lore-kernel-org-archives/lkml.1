Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYK1DKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYK1DKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 22:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYK1DJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 22:09:56 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:33789 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539AbYK1DJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 22:09:55 -0500
Date: Fri, 28 Nov 2008 12:09:54 +0900 (JST)
Message-Id: <20081128.120954.1024833258536769313.ryov@valinux.co.jp>
To: fernando@oss.ntt.co.jp
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, fchecconi@gmail.com, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <1227775382.7443.43.camel@sebastian.kern.oss.ntt.co.jp>
References: <20081126.214707.653026525707335397.ryov@valinux.co.jp>
	<20081126160805.GE27826@redhat.com>
	<1227775382.7443.43.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > I don't come up with any use case, but I would like to make the
> > > resource controller more flexible. Actually, a certain block device
> > > that I'm using does not use the I/O scheduler.
> > 
> > Isn't it equivalent to using No-op? If yes, then it should not be an
> > issue?
> 
> No, it is not equivalent. When using devices drivers that provide their
> own make_request_fn() (check for devices that invoke
> blk_queue_make_request() at initialization time) bios entering the block
> layer can go directly to the device driver and from there to the device.

As Fernando said, that device driver invokes blk_queue_make_request(),

Thanks,
Ryo Tsuruta
