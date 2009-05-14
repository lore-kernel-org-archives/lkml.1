Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZENXoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZENXoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZENXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:43:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZENXn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:43:58 -0400
Message-ID: <4A0CAC78.7060107@redhat.com>
Date: Thu, 14 May 2009 19:42:48 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped
 pages from reclaim
References: <20090513084306.5874.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905141612100.15881@qirst.com> <20090515082312.F5B6.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090515082312.F5B6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>>>> The percentage of file backed pages protected is set via
>>>> /proc/sys/vm/file_mapped_ratio. This defaults to 20%.
>>> Why do you think typical mapped ratio is less than 20% on desktop machine?
>> Observation of the typical mapped size of Firefox under KDE.
> 
> My point is, desktop people have very various mapped ratio.
> Do you oppose this?

I suspect that the mapped ratio could be much higher
on my system.  I have only 2GB of RAM dedicated to my
dom0 (which is also my desktop) and the amount of page
cache often goes down to about 150MB.

At the moment nr_mapped is 26400 and the amount of
memory taken up by buffer and page cache together is
a little over 300MB.  That's close to 50%.

-- 
All rights reversed.
