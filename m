Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYEYUrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYEYUrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYEYUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:47:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49399 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYEYUr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:47:27 -0400
Message-ID: <4839D05C.4040309@garzik.org>
Date: Sun, 25 May 2008 16:47:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: question about splice performance
References: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
In-Reply-To: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hi,
> 
> I did a really basic benchmark and was suprise about the results.
> 
> $ echo 3 > /proc/sys/vm/drop_caches
> $ time  splice-cp  vmlinux /tmp/vmlinux
> 
> real    0m10.158s
> user    0m0.002s
> sys     0m0.401s
> 
> $ echo 3 > /proc/sys/vm/drop_caches
> $ time  cp  vmlinux /tmp/vmlinux
> 
> real    0m10.590s
> user    0m0.017s
> sys     0m0.459s
> 
> 
> I was expecting splice-cp case to be faster.
> 
> Could someone enlight me ?

If you drop caches you are not measuring splice speed.

Use ramfs for your tests (guarantees data is in cache) instead.

	Jeff



