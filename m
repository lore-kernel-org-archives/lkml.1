Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZDAXia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZDAXia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZDAXiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:38:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35045 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbZDAXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:38:16 -0400
Date: Thu, 2 Apr 2009 09:18:50 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 00/35] Jeff's ReiserFS Patch Queue
Message-ID: <20090401221850.GB6776@brong.net>
References: <20090330180215.951354436@suse.com> <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain> <20090401161657.GA13802@elte.hu> <49D39642.9070606@suse.com> <20090401163407.GE22517@elte.hu> <20090401165134.GA5924@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401165134.GA5924@nowhere>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 06:51:36PM +0200, Frederic Weisbecker wrote:
> > I'll let Frederic describe it but AFAIK the patch is working fine 
> > with the BKL as a mutex and no lockdep complaints or lockups. The 
> > main focus is now on finding the performance affecting spots, 
> > because Frederic's main desktop is on reiserfs and he does not 
> > accept a slowdown :)
> 
> Hehe :-)
> No actually I would accept a tiny slowdown but I fear that the common
> reiserfs users wouldn't.

We run big(ish) imap servers with up to 80 reiserfs partitions
spread over a bunch of SCSI or SAS attached external drive units.
I'm actually surprised that the BKL isn't causing us much pain
(load is amazingly low considering how many users are on these
boxes - at least now that we have 32Gb RAM and 64 bit kernels).

Are you still using an "entire reiserfs subsystem" mutex, or
per-filesystem locking?  If it's per filesystem, then I suspect
we'll be big fans!
 
> I'm still working on this and once it's ready enough for an RFC patch,
> I'll explain how is done the conversion to a mutex.
> 
> Stay tuned.

Sure will!

Thanks,

Bron.
