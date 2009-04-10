Return-Path: <linux-kernel-owner+w=401wt.eu-S938906AbZDJHcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938906AbZDJHcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938310AbZDJHVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:21:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57998 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938279AbZDJHVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:21:12 -0400
Date: Fri, 10 Apr 2009 09:21:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 0/13] Per-bdi writeback flusher threads #3
Message-ID: <20090410072109.GK5178@kernel.dk>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com> <1239335199.2567.784.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239335199.2567.784.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10 2009, Zhang, Yanmin wrote:
> On Wed, 2009-04-08 at 14:00 +0200, Jens Axboe wrote:
> > Hi,
> > 
> > This is the third version of the patchset. Changes since v2:
> Jens,
> 
> The patchset forgets kernel/sysctl.c part, so the compilation link fails.

Yep, noticed that as well. Not really great timing with adding more
pdflush tunables...

There's also an issue with the SRCU init, so it will not even work
irregardless of the compilation problem. I'll have to update and repost
next week.

-- 
Jens Axboe

