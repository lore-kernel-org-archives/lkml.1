Return-Path: <linux-kernel-owner+w=401wt.eu-S936189AbYEVNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189AbYEVNK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935841AbYEVNKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:10:40 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16910 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935752AbYEVNKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:10:39 -0400
Date: Thu, 22 May 2008 15:10:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Move the second call to get_request to the end of the loop
Message-ID: <20080522131036.GH7712@kernel.dk>
References: <1211444984.3177.256.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211444984.3177.256.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22 2008, Zhang, Yanmin wrote:
> In function get_request_wait, the second call to get_request could be
> moved to the end of the while loop, because if the first call to
> get_request fails, the second call will fail without sleep.

Looks safe enough, since we don't drop the lock in between getting the
request and adding to the wait queue. I'll add it to the testing mix,
thanks!


-- 
Jens Axboe

