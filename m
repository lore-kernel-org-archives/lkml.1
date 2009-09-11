Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZIKHRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZIKHRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZIKHRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:17:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52437 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZIKHRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:17:51 -0400
Date: Fri, 11 Sep 2009 09:17:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Mark Landis <mark.landis@teradata.com>, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCH linux-2.6-block#for-2.6.32] Seperate read and
	write statistics of in_flight requests
Message-ID: <20090911071753.GC18599@kernel.dk>
References: <200908241603.15158.knikanth@suse.de> <20090824110735.GI12579@kernel.dk> <200908241754.08592.knikanth@suse.de> <200909110913.46769.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909110913.46769.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Nikanth Karthikesan wrote:
> Currently, there is a single in_flight counter measuring the number of
> requests in the request_queue. But some monitoring tools would like to
> know how many read requests and write requests are in progress. Split the
> current in_flight counter into two seperate counters for read and write.
> 
> This information is exported as a sysfs attribute, as changing the
> currently available stat files would break the existing tools.

Applied, this is better than breaking existing stat exports.

-- 
Jens Axboe

