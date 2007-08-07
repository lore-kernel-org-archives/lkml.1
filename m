Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbXHGQHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbXHGQHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXHGQGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:06:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41433 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbXHGQGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:06:51 -0400
Message-ID: <46B89899.5020303@garzik.org>
Date: Tue, 07 Aug 2007 12:06:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain>
In-Reply-To: <1186458941.6637.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> OK ... that's arguable.  This one is larger than I like because of the
> lpfc bug fix patch ... I accept I need to do a better job getting these
> into the merge window via the scsi-misc tree.  So I will accept the "too
> big" criticism and try to manage the driver maintainers better.
> 
> However, I won't accept the "not bug fixes only" criticism at -rc1.  The
> problem is that we're trying to stabilise a new feature: bsg.

Just so we don't lose the forest for the trees...

Not trying to put words in Linus's mouth, but it seems to me he wasn't 
complaining specifically about bsg.  "style cleanups", "cosmetic 
cleanups", ancient ISA driver polishing (1542, my gdth patch) are 
definitely not "bug fix only" material.

The lpfc update was probably the biggest thing, LOC-wise.  And even 
though that was mostly bug fixes -- and notably NOT 100% fixes -- it is 
big enough to warrant integration testing and exposure prior to 
mainline.  Definitely merge-window-open material AFAICS.

	Jeff


