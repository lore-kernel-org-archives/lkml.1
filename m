Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZETOrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZETOrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZETOrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:47:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZETOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:47:32 -0400
Date: Wed, 20 May 2009 16:47:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090520144731.GB4753@basil.nowhere.org>
References: <alpine.DEB.1.10.0905181045340.20244@qirst.com> <20090519032759.GA7608@localhost> <20090519133422.4ECC.A69D9226@jp.fujitsu.com> <20090519062503.GA9580@localhost> <87pre4nhqf.fsf@basil.nowhere.org> <20090520143258.GA5706@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520143258.GA5706@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One scenario that might be useful to test is what happens when some
> > very large processes, all mapped and executable exceed memory and
> 
> Good idea. Too bad I may have to install some bloated desktop in order
> to test this out ;) I guess the pgmajfault+pswpin numbers can serve as
> negative scores in that case?

I would just generate a large C program with a script and compile
and run that. The program can be very dumb (e.g. only run
a gigantic loop), it just needs to be large.

Just don't compile it with optimization, that can be quite slow.

And use multiple functions, otherwise gcc might exceed your memory.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
