Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZE1W25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZE1W25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZE1W2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:28:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37154 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZE1W2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:28:48 -0400
Date: Fri, 29 May 2009 00:28:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090528222849.GG11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <1243518961.6600.155.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243518961.6600.155.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28 2009, Peter Zijlstra wrote:
> On Thu, 2009-05-28 at 13:46 +0200, Jens Axboe wrote:
> > - Get rid of the explicit wait queues, we can just use wake_up_process()
> >   since it's just for that one task.
> 
> Ah, good, should clean up those funny prepare/finish_wait thingies that
> looked odd.

Precisely, they are gone now :-)

-- 
Jens Axboe

