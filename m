Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZETMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZETMGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZETMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:06:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbZETMGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:06:08 -0400
Date: Wed, 20 May 2009 14:06:08 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 04/11] writeback: separate the flushing state/task from
	the bdi
Message-ID: <20090520120608.GE3760@duck.suse.cz>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-5-git-send-email-jens.axboe@oracle.com> <20090520113430.GD3760@duck.suse.cz> <20090520113918.GU11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520113918.GU11363@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-05-09 13:39:18, Jens Axboe wrote:
> On Wed, May 20 2009, Jan Kara wrote:
> > On Mon 18-05-09 14:19:45, Jens Axboe wrote:
> > > Add a struct bdi_writeback for tracking and handling dirty IO. This
> > > is in preparation for adding > 1 flusher task per bdi.
> >   Some changes (IMO the most complicated ones ;) in this patch set seem to
> > be just reordering / cleanup of changes which happened in patch #2. Could
> > you maybe move it there. Commented below...
> 
> Some of it, most of it is due to switching from one fixed thread to the
> potential of having lots more. The moving code around is mostly due to
> other callers now having to use functions that were below them, and I'd
> rather move them around instead of having prototypes at the top.
  I meant mainly the changes in forker thread and such.

> It would be easy to unify the two patches, but I wanted to separate the
> switch from pdflush to 1 bdi thread from the transition from 1 bdi
> thread to several.
  Yes, this is probably desirable.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
