Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbZFPVzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbZFPVzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZFPVzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:55:07 -0400
Received: from cmpxchg.org ([85.214.51.133]:53277 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbZFPVzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:55:06 -0400
Date: Tue, 16 Jun 2009 23:52:00 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
Message-ID: <20090616215200.GA19781@cmpxchg.org>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <20090616200852.GA16265@cmpxchg.org> <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added Andrew on Cc]

On Tue, Jun 16, 2009 at 09:57:30PM +0100, Hugh Dickins wrote:
> On Tue, 16 Jun 2009, Johannes Weiner wrote:
> > 
> > Did you have a particular reason not to pass in the faulting mm
> > instead?
> 
> No good reason.

Okay.

> > As the swap token should only care about the faulting address space
> > leading to swap io and not about the running process anyway, we could
> > do it like below and remove all those pesky current->derefs in the
> > same go.  What do you think?
> 
> I think we'll have to claim joint authorship.

That's for sure, I just didn't want to plant it on you :)

> But I win by one checkpatch point, and a few minutes ;)

Checkpatch compatibility restored, now back to the time machine!
