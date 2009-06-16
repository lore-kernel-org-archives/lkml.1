Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbZFPU6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbZFPU6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbZFPU6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:58:30 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:46807 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760178AbZFPU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:58:30 -0400
X-Trace: 216389553/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.95.160/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.95.160
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGAL+jN0pQKV+g/2dsb2JhbACBT9NkhAsF
X-IronPort-AV: E=Sophos;i="4.42,231,1243810800"; 
   d="scan'208";a="216389553"
Date: Tue, 16 Jun 2009 21:57:30 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
In-Reply-To: <20090616200852.GA16265@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random>
 <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <20090616200852.GA16265@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Johannes Weiner wrote:
> 
> Did you have a particular reason not to pass in the faulting mm
> instead?

No good reason.

> 
> As the swap token should only care about the faulting address space
> leading to swap io and not about the running process anyway, we could
> do it like below and remove all those pesky current->derefs in the
> same go.  What do you think?

I think we'll have to claim joint authorship.
But I win by one checkpatch point, and a few minutes ;)

Hugh
