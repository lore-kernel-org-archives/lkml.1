Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbXD0KAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbXD0KAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXD0KAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:00:06 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35435 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbXD0KAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:00:04 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 06:00:04 EDT
From: Oliver Neukum <oliver@neukum.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 11:50:55 +0200
User-Agent: KMail/1.9.1
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271150.55701.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 27. April 2007 08:18 schrieb Pekka J Enberg:
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > COW is a possibility, but I understood (perhaps wrongly) that Linus was
> > thinking of a single syscall or such like to prepare the snapshot. If
> > you're going to start doing things like this, won't that mean you'd then
> > have to update/redo the snapshot or somehow nullify the effect of
> > anything the programs does so that doing it again after the snapshot is
> > restored doesn't cause problems?
> 
> No. The snapshot is just that. A snapshot in time. From kernel point of 
> view, it doesn't matter one bit what when you did it or if the state has 
> changed before you resume. It's up to userspace to make sure the user 
> doesn't do real work while the snapshot is being written to disk and 
> machine is shut down.

And where is the benefit in that? How is such user space freezing logic
simpler than having the kernel do the write?
What can you do in user space if all filesystems are r/o that is worth the
hassle?

	Regards
		Oliver
