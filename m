Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZGIUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZGIUPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZGIUPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:15:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42513 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbZGIUPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:15:12 -0400
Date: Thu, 9 Jul 2009 22:15:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in
	cfq_find_alloc_queue()
Message-ID: <20090709201510.GU23611@kernel.dk>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> <1246007120-24034-3-git-send-email-jens.axboe@oracle.com> <x497hyz9d2g.fsf@segfault.boston.devel.redhat.com> <20090627182617.GX23611@kernel.dk> <20090709154446.GD30832@redhat.com> <20090709173823.GN23611@kernel.dk> <20090709195941.GE30832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709195941.GE30832@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09 2009, Vivek Goyal wrote:
> Sure. Here you go.
> 
> In case memory is scarce, we now default to oom_cfqq. Once memory is
> available again, we should allocate a new cfqq and stop using oom_cfqq for
> a particular io context.
> 
> Once a new request comes in, check if we are using oom_cfqq, and if yes,
> try to allocate a new cfqq.
> 
> Tested the patch by forcing the use of oom_cfqq and upon next request thread
> realized that it was using oom_cfqq and it allocated a new cfqq.

Thanks, applied!

-- 
Jens Axboe

