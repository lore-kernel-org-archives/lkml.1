Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZDWA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZDWA12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZDWA1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:27:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42466 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZDWA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:27:18 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 18/22] Use allocation flags as an index to the zone watermark
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240422423.10627.96.camel@nimitz>
References: <20090422171451.GG15367@csn.ul.ie> <1240422423.10627.96.camel@nimitz>
Message-Id: <20090423092350.F6E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 23 Apr 2009 09:27:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-04-22 at 18:14 +0100, Mel Gorman wrote:
> > Preference of taste really. When I started a conversion to accessors, it
> > changed something recognised to something new that looked uglier to me.
> > Only one place cares about the union enough to access is via an array so
> > why spread it everywhere.
> 
> Personally, I'd say for consistency.  Someone looking at both forms
> wouldn't necessarily know that they refer to the same variables unless
> they know about the union.

for just clalification...

AFAIK, C language specification don't gurantee point same value.
compiler can insert pad between struct-member and member, but not insert
into array.

However, all gcc version don't do that. I think. but perhaps I missed
some minor gcc release..


So, I also like Dave's idea. but it only personal feeling.



