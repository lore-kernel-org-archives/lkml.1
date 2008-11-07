Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYKGLDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYKGLDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYKGLDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:03:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52129 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYKGLDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:03:43 -0500
Date: Fri, 7 Nov 2008 20:02:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into
 pcp
Message-Id: <20081107200251.15e9851a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081107104242.GC13786@csn.ul.ie>
References: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081106164644.GA14012@csn.ul.ie>
	<20081107104224.1631057e.kamezawa.hiroyu@jp.fujitsu.com>
	<20081107104242.GC13786@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 10:42:42 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Nov 07, 2008 at 10:42:24AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 6 Nov 2008 16:46:45 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > > > otherwise, the system have unnecessary memory starvation risk
> > > > because other cpu can't use this emergency pages.
> > > > 
> > > > 
> > > > 
> > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > CC: Mel Gorman <mel@csn.ul.ie>
> > > > CC: Christoph Lameter <cl@linux-foundation.org>
> > > > 
> > > 
> > > This patch seems functionally sound but as Christoph points out, this
> > > adds another branch to the fast path. Now, I ran some tests and those that
> > > completed didn't show any problems but adding branches in the fast path can
> > > eventually lead to hard-to-detect performance problems.
> > > 
> > dividing pcp-list into MIGRATE_TYPES is bad ?
> 
> I do not understand what your question is.
> 
Hmm. like this.

	 pcp = &zone_pcp(zone, get_cpu())->pcp[migrate_type];

	
Thanks,
-Kame

