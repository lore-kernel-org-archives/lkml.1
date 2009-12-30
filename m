Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZL3MyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZL3MyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZL3MyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:54:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48490 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZL3MyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:54:22 -0500
Date: Wed, 30 Dec 2009 21:53:41 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 4/4] memcg: add anon_scan_ratio to memory.stat file
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091229140957.GR3601@balbir.in.ibm.com>
References: <20091228164857.A690.A69D9226@jp.fujitsu.com> <20091229140957.GR3601@balbir.in.ibm.com>
Message-Id: <20091230215052.1A13.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-12-28 16:49:27]:
> 
> > anon_scan_ratio feature doesn't only useful for global VM pressure
> > analysis, but it also useful for memcg memroy pressure analysis.
> > 
> > Then, this patch add anon_scan_ratio field to memory.stat file too.
> > 
> > Instead, following debug statistics was removed. It isn't so user and/or
> > developer friendly.
> > 
> > 	- recent_rotated_anon
> > 	- recent_rotated_file
> > 	- recent_scanned_anon
> > 	- recent_scanned_file
> 
> I've been using these to look at statistics - specifically reclaim
> data on my developer kernels.

ok, I'll drop removing part. just add anon_scan_ratio.


