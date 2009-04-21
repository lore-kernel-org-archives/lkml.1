Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZDUKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZDUKXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZDUKXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:23:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35046 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZDUKXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:23:02 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 13/25] Inline __rmqueue_smallest()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421101115.GP12713@csn.ul.ie>
References: <20090421185025.F156.A69D9226@jp.fujitsu.com> <20090421101115.GP12713@csn.ul.ie>
Message-Id: <20090421192141.F168.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 19:22:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this better?
> 
> Inline __rmqueue_smallest by altering flow very slightly so that there
> is only one call site. Because there is only one call-site, this
> function can then be inlined without causing text bloat.

very nice.


> I don't see a need to add a comment into the function itself as I don't
> think it would help any.

ok. I drop my claim.


