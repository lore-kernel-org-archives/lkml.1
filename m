Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZJ2XoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZJ2XoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 19:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZJ2XoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 19:44:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40101 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZJ2XoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 19:44:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Oct 2009 08:41:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
Message-Id: <20091030084134.fc968a90.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910290232000.21298@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
	<abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
	<20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>
	<20091029174632.8110976c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290156560.16347@chino.kir.corp.google.com>
	<20091029181650.979bf95c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290232000.21298@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 02:44:45 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:
> >   Then,
> >   - I'd like to drop file_rss.
> >   - I'd like to take swap_usage into acccount.
> >   - I'd like to remove cpu_time bonus. runtime bonus is much more important.
> >   - I'd like to remove penalty from children. To do that, fork-bomb detector
> >     is necessary.
> >   - nice bonus is bad. (We have oom_adj instead of this.) It should be
> >     if (task_nice(p) < 0)
> > 	points /= 2;
> >     But we have "root user" bonus already. We can remove this line.
> > 
> > After above, much more simple selection, easy-to-understand,  will be done.
> > 
> 
> Agreed, I think we'll need to rewrite most of the heuristic from scratch.

I'd like to post total redesgin of oom-killer in the next week.
plz wait.

Thanks,
-Kame

