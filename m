Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZHFHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZHFHD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZHFHD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:03:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49153 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZHFHD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:03:26 -0400
Date: Thu, 6 Aug 2009 09:03:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 6/9] writeback: allow sleepy exit of default writeback
	task
Message-ID: <20090806070326.GG12579@kernel.dk>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-7-git-send-email-jens.axboe@oracle.com> <20090805195757.GE27505@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805195757.GE27505@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05 2009, Jan Kara wrote:
> On Thu 30-07-09 23:24:01, Jens Axboe wrote:
> > Since we do lazy create of default writeback tasks for a bdi, we can
> > allow sleepy exit if it has been completely idle for 5 minutes.
>   Maybe there should be a sysfs tunable to this?

Not sure, and when in doubt I prefer not to do that. But we could easily
add one, if people think it will be useful. What would the reason for
turning it off be?

-- 
Jens Axboe

