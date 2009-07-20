Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZGTQXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZGTQXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZGTQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:23:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36109 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZGTQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:23:12 -0400
Date: Tue, 21 Jul 2009 01:22:25 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 3/3] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0907201126390.20389@gentwo.org>
References: <20090720143838.7481.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907201126390.20389@gentwo.org>
Message-Id: <20090721012054.AF7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 20 Jul 2009, KOSAKI Motohiro wrote:
> 
> > > On Fri, 17 Jul 2009, KOSAKI Motohiro wrote:
> > >
> > > > > Why do a separate pass over all the migrates pages? Can you add the
> > > > > _inc_xx  somewhere after the page was isolated from the lru by calling
> > > > > try_to_unmap()?
> > > >
> > > > calling try_to_unmap()? the pages are isolated before calling migrate_pages().
> > > > migrate_pages() have multiple caller. then I put this __inc_xx into top of
> > > > migrate_pages().
> > >
> > > Then put the inc_xxx's where the pages are isolated.
> >
> > Is there any benefit? Why do we need sprinkle __inc_xx to many place?
> 
> Its only needed in one place where the pages are isolated.

Umm.. I haven't understand this benefit. but I guess I can do that.
I'll think it later deeply.




