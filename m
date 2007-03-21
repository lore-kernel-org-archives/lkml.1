Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbXCUT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbXCUT7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933996AbXCUT7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:59:54 -0400
Received: from brick.kernel.dk ([62.242.22.158]:25477 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933998AbXCUT7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:59:52 -0400
Date: Wed, 21 Mar 2007 20:59:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dale Blount <linux-kernel@dale.us>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests  (2.6.21-rc2 and 2.6.20)
Message-ID: <20070321195928.GG15024@kernel.dk>
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk> <loom.20070321T135132-397@post.gmane.org> <460174EC.8000608@redhat.com> <1174501407.14261.34.camel@dale.velocity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174501407.14261.34.camel@dale.velocity.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21 2007, Dale Blount wrote:
> On Wed, 2007-03-21 at 14:09 -0400, Chuck Ebbert wrote:
> > Dale Blount wrote:
> > >> I'm puzzled why this is hitting Dan, but no one else has reported
> > >> anything. Dan, did 2.6.19 work for you?
> > > 
> > > Actually, I believe it is happening to me too.  This is on a 4-disk raid5 with
> > > one failed disk on two 2-port sata_sil pci controller cards.
> > > 
> > > The BUG below is from 2.6.20.3, but I will try 2.6.21-rc4 tonight.
> > > The disk didn't fail until 2.6.20, so I don't know if 2.6.19 would have worked
> > > or not.
> > > 
> > > 
> > 
> > Just to be clear: you have a RAID array (what level?) with a failed disk
> > and it's giving you the same error that Dan gets?
> 
> 
> Yes, the BUG looks to be pretty similar to me.  It's a 4 disk raid5 with
> one disk missing (dead and sent in for RMA).

Interesting, I'll definitely see if I can reproduce it like that.

-- 
Jens Axboe

