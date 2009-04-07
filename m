Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZDGFoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZDGFoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZDGFoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:44:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38297 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZDGFoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:44:46 -0400
Date: Tue, 7 Apr 2009 07:44:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, torvalds@linux-foundation.org
Subject: Re: [PATCH] md/raid1: fix build breakage
Message-ID: <20090407054444.GK5178@kernel.dk>
References: <20090406213556.GA29973@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406213556.GA29973@orion>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07 2009, Alexander Beregalov wrote:
> Fix this build error:
> drivers/md/raid1.c: In function 'raid1_congested':
> drivers/md/raid1.c:589: error: 'BDI_write_congested' undeclared
> 
> BDI_write_congested was changed in 1faa16d2
> (block: change the request allocation/congestion logic to be sync/async
> based)

Strange, I was so sure I had grepped for those. Thanks for the
quick-fix, I see Linus already added it.

-- 
Jens Axboe

