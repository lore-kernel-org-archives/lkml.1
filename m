Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZHXLHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZHXLHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZHXLHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:07:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53186 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZHXLHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:07:34 -0400
Date: Mon, 24 Aug 2009 13:07:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Mark Landis <mark.landis@teradata.com>, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Seperate read and write statistics of in_flight
	requests
Message-ID: <20090824110735.GI12579@kernel.dk>
References: <200908241603.15158.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908241603.15158.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24 2009, Nikanth Karthikesan wrote:
> Currently, there is a single in_flight counter measuring the number of
> requests in the request_queue. But some monitoring tools would like to know
> how many read requests and write requests are in progress. Split the current
> in_flight counter into two seperate counters for read and write.
> 
> This patch is based on a patch from Mark Landis <mark.landis@teradata.com>

With fear of stating the obvious, this changes the output format of the
exported stat files. This can/will break existing tools.

-- 
Jens Axboe

