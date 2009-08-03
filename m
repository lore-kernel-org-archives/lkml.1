Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZHCMVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZHCMVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZHCMVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:21:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44895 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbZHCMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:21:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com>
References: <77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com> <alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com>
Message-Id: <20090803212059.CC2C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  3 Aug 2009 21:21:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 1 Aug 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Summarizing I think now .....
> >   - rename mm->oom_adj as mm->effective_oom_adj
> >   - re-add per-thread oom_adj
> >   - update mm->effective_oom_adj based on per-thread oom_adj
> >   - if necessary, plz add read-only /proc/pid/effective_oom_adj file.
> >     or show 2 values in /proc/pid/oom_adj
> >   - rewrite documentation about oom_score.
> >    " it's calclulated from  _process's_ memory usage and oom_adj of
> >     all threads which shares a memor  context".
> >    This behavior is not changed from old implemtation, anyway.
> >  - If necessary, rewrite oom_kill itself to scan only thread group
> >    leader. It's a way to go regardless of  vfork problem.
> > 
> 
> Ok, so you've abandoned the signal_struct proposal and now want to add it 
> back to task_struct with an effective member in mm_struct by changing the 
> documentation.  Hmm.

Oops, please see From line. The page was made from me ;)


