Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZKCX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZKCX6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZKCX6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:58:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59438 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZKCX6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:58:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 08:56:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 0/6] oom-killer: total renewal
Message-Id: <20091104085604.f6e8b162.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031229590.25890@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031229590.25890@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 12:34:13 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Hi, as discussed in "Memory overcommit" threads, I started rewrite.
> > 
> > This is just for showing "I started" (not just chating or sleeping ;)
> > 
> > All implemtations are not fixed yet. So feel free to do any comments.
> > This set is for minimum change set, I think. Some more rich functions
> > can be implemented based on this.
> > 
> > All patches are against "mm-of-the-moment snapshot 2009-11-01-10-01"
> > 
> > Patches are organized as
> > 
> > (1) pass oom-killer more information, classification and fix mempolicy case.
> > (2) counting swap usage
> > (3) counting lowmem usage
> > (4) fork bomb detector/killer
> > (5) check expansion of total_vm
> > (6) rewrite __badness().
> > 
> > passed small tests on x86-64 boxes.
> > 
> 
> Thanks for looking into improving the oom killer!
> 
Thank you for review.

> I think it would be easier to merge the four different concepts you have 
> here:
> 
>  - counting for swap usage (patch 2),
> 
>  - oom killer constraint reorganization (patches 1 and 3),
> 
>  - fork bomb detector (patch 4), and 
> 
>  - heuristic changes (patches 5 and 6)
> 
> into seperate patchsets and get them merged one at a time.

yes, I will do so. I think we share total view of final image.

> I think patch 2 can easily be merged into -mm now, and patches 1 and 3 could
> be merged after cleaned up. 
ok, maybe patch 1 should be separated more.

>We'll probably need more discussion on the rest.
> 
agreed.

> Patches 1 and 6 have whitespace damage, btw.
Oh, will fix.

Thanks,
-Kame


