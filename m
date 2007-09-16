Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbXIPWon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbXIPWon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXIPWod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:44:33 -0400
Received: from lazybastard.de ([212.112.238.170]:41579 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbXIPWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:44:32 -0400
Date: Mon, 17 Sep 2007 00:40:22 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Joern Engel <joern@logfs.org>, Andrea Arcangeli <andrea@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916224022.GA3573@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random> <20070916174657.GA2393@lazybastard.org> <87d4wi5kpr.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d4wi5kpr.fsf@informatik.uni-tuebingen.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 September 2007 00:06:24 +0200, Goswin von Brederlow wrote:
> 
> How probable is it that the dentry is needed again? If you copy it and
> it is not needed then you wasted time. If you throw it out and it is
> needed then you wasted time too. Depending on the probability one of
> the two is cheaper overall. Idealy I would throw away dentries that
> haven't been accessed recently and copy recently used ones.
> 
> How much of a systems ram is spend on dentires? How much on task
> structures? Does anyone have some stats on that? If it is <10% of the
> total ram combined then I don't see much point in moving them. Just
> keep them out of the way of users memory so the buddy system can work
> effectively.

As usual, the answer is "it depends".  I've had up to 600MB in dentry
and inode slabs on a 1GiB machine after updatedb.  This machine
currently has 13MB in dentries, which seems to be reasonable for my
purposes.

Jörn

-- 
Audacity augments courage; hesitation, fear.
-- Publilius Syrus
