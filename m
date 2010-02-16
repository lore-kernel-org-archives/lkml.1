Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab0BPXwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:52:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46600 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab0BPXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:52:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 08:48:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 8/9 v2] oom: avoid oom killer for lowmem allocations
Message-Id: <20100217084858.fd72ec4f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002160024370.15201@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com>
	<20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
	<20100216064402.GC5723@laptop>
	<alpine.DEB.2.00.1002152334260.7470@chino.kir.corp.google.com>
	<20100216075330.GJ5723@laptop>
	<alpine.DEB.2.00.1002160024370.15201@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 00:25:22 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 16 Feb 2010, Nick Piggin wrote:
> 
> > > I'll add this check to __alloc_pages_may_oom() for the !(gfp_mask & 
> > > __GFP_NOFAIL) path since we're all content with endlessly looping.
> > 
> > Thanks. Yes endlessly looping is far preferable to randomly oopsing
> > or corrupting memory.
> > 
> 
> Here's the new patch for your consideration.
> 

Then, can we take kdump in this endlessly looping situaton ?

panic_on_oom=always + kdump can do that. 

Thanks,
-Kame

