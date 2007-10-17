Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXJQT0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXJQT0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXJQTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:25:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17512 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXJQTZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:25:52 -0400
Date: Wed, 17 Oct 2007 21:25:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017192546.GZ15552@kernel.dk>
References: <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190422.GA12711@elte.hu> <20071017190821.GX15552@kernel.dk> <20071017191456.GA14916@elte.hu> <20071017191743.GA15870@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017191743.GA15870@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
> > > > drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
> > > > 
> > > > not sure it matters.
> > > 
> > > Hmm, I don't see them here (gcc 4.2.1). Must be the BUG(), does it go 
> > > away if you add a index = -1 in the default: case? Just to be 
> > > absolutely sure...
> > 
> > well if i initialize the variable then of course the warning goes away
> > :)
> > 
> > NOTE: i get the same warning even without the BUG_ON() patch, and 
> > without your other fix patch as well. I'm using gcc 4.2.2. (Do you get 
> > the warning if you pick up the config i sent you earlier today?)
> 
> btw., i changed the initialization to -1 and the crash still occurs 
> (as expected).

Would think so, thanks for checking though.

-- 
Jens Axboe

