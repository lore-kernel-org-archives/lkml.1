Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZDWKlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZDWKlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZDWKk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:40:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57450 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbZDWKk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:40:56 -0400
Date: Thu, 23 Apr 2009 12:40:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090423104055.GU4593@kernel.dk>
References: <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk> <20090422163705.GW4593@kernel.dk> <49EF5F31.30408@opengridcomputing.com> <20090422183406.GA4593@kernel.dk> <49EF6929.9020600@opengridcomputing.com> <20090422192216.GE4593@kernel.dk> <49EF7B40.9050505@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF7B40.9050505@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Steve Wise wrote:
> Jens Axboe wrote:
>
>  
>
>>> Still crashes with this variant:
>>>     
>>
>> OK, so please try and revert a36e71f996e25d6213f57951f7ae1874086ec57e
>> and see if that works?
>>
>> Or, better yet, please try and revert
>> 55a63998b8967615a15e2211ba0ff3a84a565824 first. If that doesn't work,
>> try the above revert.
>>
>>   
>
> Reverting 55a63998b8967615a15e2211ba0ff3a84a565824 did the trick.

Steve, can you (and Balbir) try with pulling this into 2.6.30-rc3:

        git://git.kernel.dk/linux-2.6-block.git for-linus

It has two fixes for possible rbtree misuse in cfq. If it still crashes
without reverting 55a63998b8967615a15e2211ba0ff3a84a565824 with that,
then we also need to look further into the rbtree issue.

Thanks!

-- 
Jens Axboe

