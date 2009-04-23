Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZDWBZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZDWBZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZDWBY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:24:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:45618 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZDWBY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:24:56 -0400
Message-ID: <49EFC360.3010109@kernel.org>
Date: Thu, 23 Apr 2009 10:24:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH 09/14] block: clean up request completion API
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-10-git-send-email-tj@kernel.org> <20090421175919.GA11671@infradead.org>
In-Reply-To: <20090421175919.GA11671@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 01:24:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> +EXPORT_SYMBOL_GPL(__blk_end_io);
> 
> That's really ugly code due to the locked argument.

Yeap, it's ugly.  Thought having one ugly path would be better than
duplicate implementations.

> Just make a helper for all code down to add_disk_randomness, and
> have two different functions call that and finish_request +/- the
> locking.

Alright, will change toward that direction.

Thanks.

-- 
tejun
