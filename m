Return-Path: <linux-kernel-owner+w=401wt.eu-S2992874AbXDYRTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992874AbXDYRTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992864AbXDYRTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:19:13 -0400
Received: from brick.kernel.dk ([80.160.20.94]:25682 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992866AbXDYRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:19:12 -0400
Date: Wed, 25 Apr 2007 19:15:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan.Brunelle@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] cfq-iosched: speed up rbtree handling
Message-ID: <20070425171539.GE4730@kernel.dk>
References: <11774025432481-git-send-email-jens.axboe@oracle.com> <11774025432403-git-send-email-jens.axboe@oracle.com> <462F7AD9.8020300@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462F7AD9.8020300@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Alan D. Brunelle wrote:
> Hi Jens -
> 
> The attached patch speeds it up even more - I'm finding a >9% reduction 
> in %system with no loss in IO performance. This just sets the cached 
> element when the first is looked for.

Interesting, good thinking. It should not change the IO pattern, as the
end result should be the same. Thanks Alan, will commit!

I'll give elevator.c the same treatment, should be even more beneficial.
Stay tuned for a test patch.

-- 
Jens Axboe

