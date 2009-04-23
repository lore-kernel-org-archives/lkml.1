Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZDWBXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZDWBXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZDWBXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:23:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZDWBXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:23:14 -0400
Message-ID: <49EFC2F7.9050906@kernel.org>
Date: Thu, 23 Apr 2009 10:23:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com
Subject: Re: [PATCH 07/14] block: reorganize request fetching functions
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-8-git-send-email-tj@kernel.org> <20090421170751.GA21156@infradead.org> <20090422100916.GZ4593@kernel.dk>
In-Reply-To: <20090422100916.GZ4593@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 01:23:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Apr 21 2009, Christoph Hellwig wrote:
>> On Wed, Apr 22, 2009 at 01:37:54AM +0900, Tejun Heo wrote:
>>> Impact: code reorganization
>>>
>>> elv_next_request() and elv_dequeue_request() are public block layer
>>> interface than actual elevator implementation.  They mostly deal with
>>> how requests interact with block layer and low level drivers at the
>>> beginning of rqeuest processing whereas __elv_next_request() is the
>>> actual eleveator request fetching interface.
>>>
>>> Move the two functions to blk-core.c.  This prepares for further
>>> interface cleanup.
>> As a follow-up patch you might want to rename them to have a more
>> descriptive prefix than elv_ and add some kerneldoc comments for them.
> 
> Hmm dunno, elv_ is fine with me. kerneldoc is always nice, though.
> 

Both changes are scheduled down the pipeline.

Thanks.

-- 
tejun
