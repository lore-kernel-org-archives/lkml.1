Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbZGHBoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbZGHBoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 21:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZGHBoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 21:44:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:1611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbZGHBog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 21:44:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,365,1243839600"; 
   d="scan'208";a="162567500"
Date: Wed, 8 Jul 2009 09:44:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Message-ID: <20090708014425.GA6464@localhost>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com> <20090705182451.08FF.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071238570.5124@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907071238570.5124@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 12:46:54AM +0800, Christoph Lameter wrote:
> On Sun, 5 Jul 2009, KOSAKI Motohiro wrote:
> 
> >  mm/vmstat.c            |    2 +-
> >  6 files changed, 14 insertions(+), 3 deletions(-)
> >
> > Index: b/fs/proc/meminfo.c
> > ===================================================================
> > --- a/fs/proc/meminfo.c
> > +++ b/fs/proc/meminfo.c
> > @@ -65,6 +65,7 @@ static int meminfo_proc_show(struct seq_
> >  		"Active(file):   %8lu kB\n"
> >  		"Inactive(file): %8lu kB\n"
> >  		"Unevictable:    %8lu kB\n"
> > +		"IsolatedPages:  %8lu kB\n"
> 
> Why is it called isolatedpages when we display the amount of memory in
> kilobytes?

See following emails. This has been changed to "IsolatedLRU" and then
"Isolated(file)/Isolated(anon)".

Thanks,
Fengguang
