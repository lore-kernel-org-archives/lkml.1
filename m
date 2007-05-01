Return-Path: <linux-kernel-owner+w=401wt.eu-S1031668AbXEALTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031668AbXEALTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031672AbXEALTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:19:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031668AbXEALTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:19:45 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       mathieu.desnoyers@polymtl.ca, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 May 2007 14:17:03 +0200
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
Message-ID: <p733b2gzqkg.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:


> Static markers.  Will merge.
There don't seem to be any users of this. How do you know it hasn't
already bitrotted?

It seems quite overcomplicated to me. Has the complexity been justified?

> 
> Will merge the rustyvisor.

IMHO the user code still doesn't belong into Documentation.
Also it needs another review round I guess. And some beta testing by
more people.
 
> Hopefully Wu will be coming up with a much simpler best-of-readahead patch
> soon.  I don't think we can get these patches over the hump and they are
> somewhat costly to maintain.

Didn't he have one already? There was a relatively simple readahead
patch recently, although it was unclear what dependencies it needed.
IMHO this work has much potential so i hope the benchmarking-review process
can be done quickly.

-Andi
