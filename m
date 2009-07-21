Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZGUHUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZGUHUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZGUHUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:20:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZGUHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:20:33 -0400
Date: Tue, 21 Jul 2009 16:19:30 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
In-Reply-To: <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
References: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com> <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
Message-Id: <20090721161319.2ABD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jul 17, 2009 at 4:12 PM, David Rientjes<rientjes@google.com> wrote:
> >
> > My patches don't merely address threads that have an oom_adj value of
> > OOM_DISABLE while others sharing the same memory do not, they address a
> > consistency issue whereas those threads may all share memory but have
> > radically different oom_adj values: that means that only the highest
> > oom_adj value amongst them is actually used by the oom killer and all
> > other oom_adj values set by the user for those threads are wrong.
> 
> But these patches change an API that has existed for at least 4 years
> (i.e. before git history exists) and the change is known to break some
> apps that relied on the existing API. Should there be more
> justification than to fix an inconsistency that only you seem to be
> claiming is a problem? (Yes, I know it also fixes the OOM killer
> livelock, but that could be done without breaking the API).

Paul, I'd like to clarily this duscussion. Doesn't Rik's patch fix your vfork issue or
you worry about generic ABI breaking issue?


