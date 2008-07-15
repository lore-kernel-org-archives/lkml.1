Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbYGOPsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbYGOPsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761289AbYGOPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:47:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbYGOPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:47:52 -0400
Date: Tue, 15 Jul 2008 11:46:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, davem@davemloft.net,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
In-Reply-To: <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.64.0807151143050.29803@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
 <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Even if we fix it now, the question is: how long it will stay fixed? Until
>> someone makes another change to struct device that restricts boundaries on
>> some wacky hardware.
>
> I'm not sure how the boundary restriction of a device can break
> the VMERGE accounting.

Because block layer code doesn't know anything about the device, pci 
access restrictions and so on.

Someone already broken DaveM's Sparc64 merging by adding boundaries (it 
was broken even before, but these boundary checks made it worse).

Mikulas
