Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZD2ADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZD2ADT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZD2ADF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:03:05 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508AbZD2ADE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:03:04 -0400
Date: Tue, 28 Apr 2009 19:02:57 -0500
From: Robin Holt <holt@sgi.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@gmail.com>,
       fengguang.wu@intel.com, mingo@elte.hu, rostedt@goodmis.org,
       fweisbec@gmail.com, lwoodman@redhat.com, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, adobriyan@gmail.com, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090429000257.GB7601@sgi.com>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu> <20090428083320.GB17038@localhost> <12c511ca0904281111r10f37a5coe5a2750f4dbfbcda@mail.gmail.com> <20090428141738.77e599f4.akpm@linux-foundation.org> <1240955395.938.1031.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240955395.938.1031.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 04:49:55PM -0500, Matt Mackall wrote:
> > Reading the state of all of memory in this fashion would be a somewhat
> > peculiar thing to do.
> 
> Not entirely. If you've got, say, a large NUMA box, it could be
> incredibly illustrative to see that "oh, this node is entirely dominated
> by SLAB allocations". Or on a smaller machine "oh, this is fragmented to
> hell and there's no way I'm going to get a huge page". Things you're not
> going to get from individual stats.

I have, in the past, simply used grep on
/sys/devices/system/node/node*/meminfo and gotten the individual stats
I was concerned about.  Not sure how much more detail would have been
needed or useful.  I don't think I can recall a time where I needed to
write another tool.

Thanks,
Robin
