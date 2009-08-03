Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZHCIEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZHCIEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZHCIEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:04:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54119 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZHCIEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:04:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 17:02:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Message-Id: <20090803170217.e98b2e46.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
	<20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
	<20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com>
	<20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
	<7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com>
	<77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com>
	<20090803104244.b58220ba.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 00:59:18 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> > >  - /proc/pid/oom_score is inconsistent when the thread that set the
> > >    effective per-mm oom_adj exits and it is now obsolete since you have
> > >    no way to determine what the next effective oom_adj value shall be.
> > > 
> > plz re-caluculate it. it's not a big job if done in lazy way.
> > 
> 
> You can't recalculate it if all the remaining threads have a different 
> oom_adj value than the effective oom_adj value from the thread that is now 
> exited.  

Then, crazy google apps pass different oom_adjs to each thread ?
And, threads other than thread-group-leader modifies its oom_adj.

Hmm, interesting.


Thanks,
-Kame

