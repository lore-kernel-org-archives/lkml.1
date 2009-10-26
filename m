Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZJZMyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZJZMyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 08:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZJZMyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 08:54:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZJZMyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 08:54:46 -0400
Message-ID: <4AE59C5A.1020305@kernel.org>
Date: Mon, 26 Oct 2009 13:55:54 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use after free bug in __blkdev_get
References: <19173.11702.129258.49993@notabene.brown> <20091026072607.GZ10727@kernel.dk>
In-Reply-To: <20091026072607.GZ10727@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Oct 26 2009, Neil Brown wrote:
>>
>> commit 0762b8bde9729f10f8e6249809660ff2ec3ad735
>> (from 14 months ago) introduced a use-after-free bug which has just
>> recently started manifesting in my md testing.
>> I tried git bisect to find out what caused the bug to start
>> manifesting, and it could have been the recent change to
>> blk_unregister_queue (48c0d4d4c04) but the results were inconclusive.
>>
>> This patch certainly fixes my symptoms and looks correct as the two
>> calls are now in the same order as elsewhere in that function.
>>
>> Signed-off-by: NeilBrown <neilb@suse.de>

Oops, thanks for catching it.

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
