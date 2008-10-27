Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYJ0BRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYJ0BRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 21:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYJ0BRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 21:17:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37700 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYJ0BRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 21:17:33 -0400
Date: Mon, 27 Oct 2008 10:17:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
 controller
Message-Id: <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
References: <20081023054335.GC3280@in.ibm.com>
	<6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
	<20081024050830.GA4387@in.ibm.com>
	<6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
	<20081025060157.GA4614@in.ibm.com>
	<6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 08:38:52 -0700
"Paul Menage" <menage@google.com> wrote:

> On Fri, Oct 24, 2008 at 11:01 PM, Bharata B Rao
> <bharata@linux.vnet.ibm.com> wrote:
> >
> > Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> Reviewed-by: Paul Menage <menage@google.com>
> 
> So in technical terms this patch looks fine now. There's still the
> question of whether it's OK to change the existing API, since it's
> been in the kernel in its currently (non-hierarchical) form for
> several releases now.
> 
Hmm..how about having 2 params as "aggregated usage" and "private usage" ?

 cpuacct.usage.
 cpuacct.all_subtree_usage.

heavy ?

-Kame

