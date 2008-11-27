Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYK0Dur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYK0Dur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 22:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYK0Dug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 22:50:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41139 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYK0Dug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 22:50:36 -0500
Date: Thu, 27 Nov 2008 12:49:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memcg reclaim shouldn't change zone->recent_rotated
 statics.
Message-Id: <20081127124946.912541e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081125155422.6ab07caf.akpm@linux-foundation.org>
References: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081125155422.6ab07caf.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 15:54:22 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 25 Nov 2008 12:22:53 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > +	if (scan_global_lru(sc))
> 
> mutter.  scan_global_lru() is a terrible function name.  Anyone reading
> that code would expect that this function, umm, scans the global LRU.
> 
> gcc has a nice convention wherein such functions have a name ending in
> "_p" (for "predicate").  Don't do this :)
> 

Hmm, I'll prepare renaming patch.

scan_global_lru_p() ? or under_scanning_global_lru() ?


Thanks,
-Kame

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

