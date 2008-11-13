Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKMCt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKMCt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYKMCtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:49:51 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47818 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYKMCtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:49:50 -0500
Date: Thu, 13 Nov 2008 11:49:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       menage@google.com
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
Message-Id: <20081113114908.42a6a8a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112160758.3dca0b22.akpm@linux-foundation.org>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112160758.3dca0b22.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 16:07:58 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> If we do this then we can make the above "keep" behaviour non-optional,
> and the operator gets to choose whether or not to drop the caches
> before doing the rmdir.
> 
> Plus, we get a new per-memcg drop_caches capability.  And it's a nicer
> interface, and it doesn't have the obvious races which on_rmdir has,
> etc.
> 
> hm?
> 

Balbir, how would you want to do ?

I planned to post shrink_uage patch later (it's easy to be implemented) regardless
of acceptance of this patch.

So, I think we should add shrink_usage now and drop this is a way to go.
I think I can prepare patch soon. But I'd like to push handle-swap-cache patch
before introducing shrink_usage. 

Then, posting following 2 patch for this week is my current intention.
 [1/2] handle swap cache
 [2/2] shrink_usage patch (instead of this patch)

Objection ?

Thanks,
-Kame

