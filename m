Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0BWTsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:48:13 -0500
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:34939 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab0BWTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:48:12 -0500
X-Greylist: delayed 4157 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 14:48:11 EST
Date: Tue, 23 Feb 2010 19:38:43 +0100 (CET)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@localhost
To: Jens Axboe <jens.axboe@oracle.com>
cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] blk-core: use BIO list management functions
In-Reply-To: <20100223145327.GE1025@kernel.dk>
Message-ID: <alpine.LFD.2.00.1002231937330.12278@localhost>
References: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com> <1266845364-3242-2-git-send-email-akinobu.mita@gmail.com> <20100223075527.GL1025@kernel.dk> <961aa3351002230626g57bbe867gb01c936897dcfedd@mail.gmail.com>
 <20100223145327.GE1025@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Jens Axboe wrote:

> On Tue, Feb 23 2010, Akinobu Mita wrote:
>> 2010/2/23 Jens Axboe <jens.axboe@oracle.com>:
>>> On Mon, Feb 22 2010, Akinobu Mita wrote:
>>>> Now that the bio list management stuff is generic, convert
>>>> generic_make_request to use bio lists instead of its own private bio
>>>> list implementation.
>>>
>>> Looks good, applied. Also saves 4 bytes in task_struct, not a bad thing
>>> :-)
>>
>> Thanks.
>>
>> How about another cleanup patch for pktcdvd?
>> http://lkml.org/lkml/2010/2/22/93
>
> Looks fine to me, I can pick it up if need be. Peter?

It looks fine to me too. Please pick it up, Jens.

Thanks.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
