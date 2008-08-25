Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYHYPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYHYPA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYHYPAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:00:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:49786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYHYPAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:00:51 -0400
Message-ID: <48B2C8A0.4070100@kernel.org>
Date: Mon, 25 Aug 2008 16:58:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jens Axboe <jens.axboe@oracle.com>, Abdel Benamrouche <draconux@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 1/3 blk-for-2.6.28] block: misc fixes and	improvements
References: <1219655740-11672-1-git-send-email-tj@kernel.org> <20080825144714.GA20813@suse.de>
In-Reply-To: <20080825144714.GA20813@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 14:59:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Recent block_class iteration updates 5c6f35c5..27f3025 introduced a
>> few bugs and trivial user visible behavior change.  0001-0003 update
>> those issues and simplify related code using new class iterator.
> 
> The bugs should now be fixed in Linus's tree due to a fix from Kay,
> right?

Ah.. okay, it's fixed in Linus's tree.  Anyways, what do you think about
the new iterator?

> The user visable behavior change, I missed that, sorry, that is a
> regression, do you think it's a big deal to fix in 2.6.27?

It's probably something which no one really cares but it's not difficult
to fix and having the behavior changed for 2.6.27 and reverted in 28
isn't too nice.  I'll send a patch.

Thanks.

-- 
tejun
