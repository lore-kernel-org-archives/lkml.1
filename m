Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZDXGld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZDXGld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZDXGlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:41:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41655 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDXGlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:41:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 18/22] Use allocation flags as an index to the zone watermark
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090423100348.GA26953@csn.ul.ie>
References: <20090423092350.F6E6.A69D9226@jp.fujitsu.com> <20090423100348.GA26953@csn.ul.ie>
Message-Id: <20090424154013.1083.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 24 Apr 2009 15:41:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Considering that they are the same type for elements and arrays, I
> didn't think padding would ever be a problem.
> 
> > However, all gcc version don't do that. I think. but perhaps I missed
> > some minor gcc release..
> > 
> > So, I also like Dave's idea. but it only personal feeling.
> > 
> 
> The tide is against me on this one :).
> 
> How about I roll a patch on top of this set that replaces the union by
> calling all sites? I figure that patch will go through a few revisions before
> people are happy with the final API. However, as the patch wouldn't change
> functionality, I'd like to see this series getting wider testing if possible. The
> replace-union-with-single-array patch can be easily folded in then when
> it settles.
> 
> Sound like a plan?

Yeah, I agree testing is important than ugliness discussion :)



