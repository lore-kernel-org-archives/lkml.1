Return-Path: <linux-kernel-owner+w=401wt.eu-S1761202AbXGQA6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761202AbXGQA6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbXGQA6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:58:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38292 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbXGQA6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:58:15 -0400
Message-ID: <469C1423.3090908@garzik.org>
Date: Mon, 16 Jul 2007 20:58:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org> <20070716175347.bea345dd.akpm@linux-foundation.org>
In-Reply-To: <20070716175347.bea345dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 16 Jul 2007 20:47:45 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Andrew Morton wrote:
>>> The modern way of shutting up gcc is uninitialized_var().
>>
>> Should I convert my misc-2.6.git#gccbug repository over to this, and 
>> push upstream?
> 
> Opinions differ (a bit) but personally I think the benefit of fixing the
> warnings outweighs the risk that these suppressions will later hide a real
> bug.

Tooting my own horn, but, anything in #gccbug I consider to be verified 
to -not- be hiding a real bug.  Human-verified not machine-verified, of 
course, so it's imperfect.  But at least it's been reviewed and 
considered carefully.

I'll look into "tarting up" #gccbug for upstream...  I had missed the 
introduction of uninitialized_var(), which was the genesis for this line 
of questioning.

	Jeff


