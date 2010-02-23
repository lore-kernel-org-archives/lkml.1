Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0BWWXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:23:04 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60531 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BWWXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:23:01 -0500
Date: Tue, 23 Feb 2010 23:23:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Osterlund <petero2@telia.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] blk-core: use BIO list management functions
Message-ID: <20100223222300.GR1025@kernel.dk>
References: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com> <1266845364-3242-2-git-send-email-akinobu.mita@gmail.com> <20100223075527.GL1025@kernel.dk> <961aa3351002230626g57bbe867gb01c936897dcfedd@mail.gmail.com> <20100223145327.GE1025@kernel.dk> <alpine.LFD.2.00.1002231937330.12278@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002231937330.12278@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23 2010, Peter Osterlund wrote:
> On Tue, 23 Feb 2010, Jens Axboe wrote:
>
>> On Tue, Feb 23 2010, Akinobu Mita wrote:
>>> 2010/2/23 Jens Axboe <jens.axboe@oracle.com>:
>>>> On Mon, Feb 22 2010, Akinobu Mita wrote:
>>>>> Now that the bio list management stuff is generic, convert
>>>>> generic_make_request to use bio lists instead of its own private bio
>>>>> list implementation.
>>>>
>>>> Looks good, applied. Also saves 4 bytes in task_struct, not a bad thing
>>>> :-)
>>>
>>> Thanks.
>>>
>>> How about another cleanup patch for pktcdvd?
>>> http://lkml.org/lkml/2010/2/22/93
>>
>> Looks fine to me, I can pick it up if need be. Peter?
>
> It looks fine to me too. Please pick it up, Jens.

Certainly, I'll queue it up for 2.6.34. I'm assuming I can add your
acked-by?

-- 
Jens Axboe

