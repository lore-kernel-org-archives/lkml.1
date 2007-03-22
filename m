Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbXCVHSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbXCVHSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXCVHSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:18:30 -0400
Received: from mx10.go2.pl ([193.17.41.74]:32774 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753251AbXCVHSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:18:30 -0400
Date: Thu, 22 Mar 2007 08:23:02 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] lockdep: lockdep_depth vs. debug_locks Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070322072302.GC2065@ff.dom.local>
References: <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru> <20070321181635.GA570@tv-sign.ru> <20070322061119.GA1466@ff.dom.local> <20070321222802.0e09f0c2.akpm@linux-foundation.org> <20070322070644.GA2065@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322070644.GA2065@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 08:06:44AM +0100, Jarek Poplawski wrote:
...
> This should definitely solve this problem - as it was said
> a few times before lockdep stops registering locks after
> a bug, so even the lock which caused the warning isn't
> reported. Here lockdep found a bug in a workqueue function,

More precisely:

lockdep found a bug during a run of workqueue function - this
could be also caused by a bug from other code running
simultaneusly.

Jarek P.
