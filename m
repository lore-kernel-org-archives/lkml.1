Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZHFS4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZHFS4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZHFS4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:56:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZHFS4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:56:02 -0400
Date: Thu, 6 Aug 2009 20:55:56 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 6/9] writeback: allow sleepy exit of default writeback
	task
Message-ID: <20090806185556.GA8177@duck.suse.cz>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-7-git-send-email-jens.axboe@oracle.com> <20090805195757.GE27505@duck.suse.cz> <20090806070326.GG12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806070326.GG12579@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-08-09 09:03:26, Jens Axboe wrote:
> On Wed, Aug 05 2009, Jan Kara wrote:
> > On Thu 30-07-09 23:24:01, Jens Axboe wrote:
> > > Since we do lazy create of default writeback tasks for a bdi, we can
> > > allow sleepy exit if it has been completely idle for 5 minutes.
> >   Maybe there should be a sysfs tunable to this?
> 
> Not sure, and when in doubt I prefer not to do that. But we could easily
> add one, if people think it will be useful. What would the reason for
> turning it off be?
  Well, I thought it might be useful mainly for debugging purposes, e.g. if
you want to watch the writeback thread and don't want it to be restarted
(as that changes it's pid etc.). I don't have a strong opinion on this, it
was just an idea.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
