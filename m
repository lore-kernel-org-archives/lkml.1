Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbZEHQGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbZEHQGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZEHQG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:06:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZEHQGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:06:25 -0400
Message-ID: <4A04580B.5050501@redhat.com>
Date: Fri, 08 May 2009 12:04:27 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Elladan <elladan@eskimo.com>
CC: Christoph Lameter <cl@linux.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first	class
 citizen
References: <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <alpine.DEB.1.10.0905070935530.24528@qirst.com> <1241705702.11251.156.camel@twins> <alpine.DEB.1.10.0905071016410.24528@qirst.com> <1241712000.18617.7.camel@lts-notebook> <alpine.DEB.1.10.0905071231090.10171@qirst.com> <4A03164D.90203@redhat.com> <20090508034054.GB1202@eskimo.com>
In-Reply-To: <20090508034054.GB1202@eskimo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elladan wrote:

>> Nobody (except you) is proposing that we completely disable
>> the eviction of executable pages.  I believe that your idea
>> could easily lead to a denial of service attack, with a user
>> creating a very large executable file and mmaping it.
>>
>> Giving executable pages some priority over other file cache
>> pages is nowhere near as dangerous wrt. unexpected side effects
>> and should work just as well.
> 
> I don't think this sort of DOS is relevant for a single user or trusted user
> system.  

Which not all systems are, meaning that the mechanism
Christoph proposes can never be enabled by default and
would have to be tweaked by the user.

I prefer code that should work just as well 99% of the
time, but can be enabled by default for everybody.
That way people automatically get the benefit.

-- 
All rights reversed.
