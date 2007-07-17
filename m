Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbXGQAsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbXGQAsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbXGQAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:47:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38213 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbXGQAr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:47:57 -0400
Message-ID: <469C11B1.8000302@garzik.org>
Date: Mon, 16 Jul 2007 20:47:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> The modern way of shutting up gcc is uninitialized_var().


Should I convert my misc-2.6.git#gccbug repository over to this, and 
push upstream?

#gccbug branch is a set of places where I have verified that the 
variable is indeed initialized, even though gcc complains it may not be.

	Jeff


