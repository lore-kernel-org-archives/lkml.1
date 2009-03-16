Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZCPKWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZCPKWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZCPKWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:22:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47794 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408AbZCPKWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:22:32 -0400
Date: Mon, 16 Mar 2009 11:22:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 4/7] writeback: get rid of task/current_is_pdflush()
Message-ID: <20090316102229.GP27476@kernel.dk>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-5-git-send-email-jens.axboe@oracle.com> <20090316101425.GB21118@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316101425.GB21118@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16 2009, Christoph Hellwig wrote:
> On Thu, Mar 12, 2009 at 03:33:45PM +0100, Jens Axboe wrote:
> > There's just a single user in the kernel and Chris says it's safe to kill.
> 
> I'll defer about the use to Chris, but if this can go it should now,
> not deep inside the series.

Oh agree, the series was more of an RFC, it wasn't a submission. It's
not even well tested yet. I'll snip the emergency sync/remount stuff and
this out of the series and put it at the front, so it can go in seperate
and earlier.

-- 
Jens Axboe

