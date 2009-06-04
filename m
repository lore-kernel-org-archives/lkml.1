Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZFDTuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZFDTuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZFDTuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:50:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34281 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZFDTuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:50:11 -0400
Date: Thu, 4 Jun 2009 21:50:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090604195013.GB11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <20090604152040.GA6007@nowhere> <20090604120726.708a2211.akpm@linux-foundation.org> <20090604191309.GA4862@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604191309.GA4862@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04 2009, Frederic Weisbecker wrote:
> On Thu, Jun 04, 2009 at 12:07:26PM -0700, Andrew Morton wrote:
> > On Thu, 4 Jun 2009 17:20:44 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > I've just tested it on UP in a single disk.
> > 
> > I must say, I'm stunned at the amount of testing which people are
> > performing on this patchset.  Normally when someone sends out a
> > patchset it just sort of lands with a dull thud.
> > 
> > I'm not sure what Jens did right to make all this happen, but thanks!
> 
> 
> I don't know how he did either. I was reading theses patches and *something*
> pushed me to my testbox, and then I tested...
> 
> Jens, how do you do that?

Heh, not sure :-)

But indeed, thanks for the testing. It looks quite interesting. I'm
guessing it probably has to do with who ends up doing the balancing and
that the flusher threads block, it may change the picture a bit. So it
may just be that it'll require a few vm tweaks. I'll definitely look
into it and try and reproduce your results.

Did you run it a 2nd time on each drive and check if the results were
(approximately) consistent on the two drives?

-- 
Jens Axboe

