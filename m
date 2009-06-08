Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZFHVQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZFHVQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZFHVQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:16:39 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:56263 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbZFHVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:16:39 -0400
X-Trace: 212042182/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.76.204/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.76.204
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEADIcLUpPRUzM/2dsb2JhbACBT80WhAoF
X-IronPort-AV: E=Sophos;i="4.41,326,1241391600"; 
   d="scan'208";a="212042182"
Date: Mon, 8 Jun 2009 22:05:51 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, aarcange@redhat.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au, chrisw@redhat.com,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] ksm: stop scan skipping pages
In-Reply-To: <4A2D70BF.9090605@redhat.com>
Message-ID: <Pine.LNX.4.64.0906082204170.23054@sister.anvils>
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906081555360.22943@sister.anvils> <Pine.LNX.4.64.0906081733390.7729@sister.anvils>
 <4A2D4D9F.8080103@redhat.com> <Pine.LNX.4.64.0906081852540.8764@sister.anvils>
 <4A2D70BF.9090605@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Izik Eidus wrote:
> Hugh Dickins wrote:
> >
> > By the time Andrew sends KVM to Linus, it shouldn't be the
> > patches currently in mmotm with more on top: 
> 
> So you want a repost of all the patchs?

Will do eventually.  In the same way that Andrew merges fixes to
patches into the patches before sending to Linus.  But in this
case, rather large pieces would vanish in such a process, plus it
would be unfair to expect Andrew to do that work; so it would
be better for you to submit replacements when we're ready.

> in that case any value to keep this
> stuff in Andrew tree right now?

I guess that depends on whether it's actually receiving any
testing or review while it's in there.  I'm happy for it to remain
there for now - and the core of it is going to remain unchanged
or only trivially changed.  Really a matter for you to decide
with Andrew: I don't want to pull it out of circulation myself.

> Wouldnt it speed our development if we will keep it outside,
> and then repost the whole thing?

I don't see that having a version there in mmotm will slow us
down (what could slow me down more than myself ;-?).  But you
and Andrew are free to decide it's counterproductive to keep the
current version there, that's okay by me if you prefer to pull it.

Hugh
