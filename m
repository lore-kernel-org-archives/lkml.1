Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZIOTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZIOTbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZIOTbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:31:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51405 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZIOTbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:31:16 -0400
Date: Tue, 15 Sep 2009 21:31:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: npiggin@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] fs: improve scalability of bdi writeback work
	queues
Message-ID: <20090915193119.GS23126@kernel.dk>
References: <20090915191903.290006007@suse.de> <20090915192242.714632996@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192242.714632996@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, npiggin@suse.de wrote:
> If you're going to do an atomic RMW on each list entry, there's not much
> point in all the RCU complexities of the list walking. This is only going
> to help the multi-thread case I guess, but it doesn't hurt to do now.

Thanks Nick, good optimization.

-- 
Jens Axboe

