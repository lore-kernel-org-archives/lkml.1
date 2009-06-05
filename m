Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZFETQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZFETQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZFETQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:16:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33759 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZFETQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:16:08 -0400
Date: Fri, 5 Jun 2009 21:16:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090605191610.GW11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <20090604152040.GA6007@nowhere> <1244164487.2560.146.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244164487.2560.146.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05 2009, Zhang, Yanmin wrote:
> On Thu, 2009-06-04 at 17:20 +0200, Frederic Weisbecker wrote:
> > Hi,
> >
> >
> > On Thu, May 28, 2009 at 01:46:33PM +0200, Jens Axboe wrote:
> > > Hi,
> > >
> > > Here's the 9th version of the writeback patches. Changes since v8:
> 
> > I've just tested it on UP in a single disk.
> >
> > I've run two parallels dbench tests on two partitions and
> > tried it with this patch and without.
> I also tested V9 with multiple-dbench workload by starting multiple
> dbench tasks and every task has 4 processes to do I/O on one partition (file
> system). Mostly I use JBODs which have 7/11/13 disks.
> 
> I didn't find result regression between ???vanilla and V9 kernel on
> this workload.

Ah that's good, thanks for that result as well :-)

-- 
Jens Axboe

