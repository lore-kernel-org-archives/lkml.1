Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZJEIqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZJEIqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbZJEIqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:46:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:36718 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758699AbZJEIqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:46:51 -0400
Date: Mon, 5 Oct 2009 01:45:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jens Axboe <jens.axboe@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com
Subject: Re: linux-next: block/drbd tree build failure
In-Reply-To: <20091005063138.GO26573@kernel.dk>
Message-ID: <alpine.DEB.2.00.0910050138351.9391@asgard.lang.hm>
References: <20091005143552.977a2d4d.sfr@canb.auug.org.au> <20091005063138.GO26573@kernel.dk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Jens Axboe wrote:

> On Mon, Oct 05 2009, Stephen Rothwell wrote:
>> Hi Jens,
>>
>> Today's linux-next build (x86_64 allmodconfig) failed like this:
>>
>> drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
>> drivers/block/drbd/drbd_req.c:43: error: subscripted value is neither array nor pointer
>> drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
>> drivers/block/drbd/drbd_req.c:56: error: subscripted value is neither array nor pointer
>>
>> I reported a similar error against the dbd tree, which was fixed, but now
>> the commit that caused that error has been reverted and thus we get
>> this :-(
>>
>> I have reverted the drbd commits from the block tree for today.
>
> That's probably my fault, not drbd. I moved it to a new branch since it
> isn't going into 2.6.32, and perhaps dropped that fix along the way.
> I'll look into it.


what needs to happen to get drbd accepted at this point? It sounded like 
they had the tree in good shape to be merged, except for the desire that 
was expressed to have them re-work all existing raid implementations 
before adding their code (and it sounded like that was not going to be 
allowed to hold it up)

David Lang

