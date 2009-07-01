Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZGARYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZGARYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZGARYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:24:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35494 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbZGARYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:24:03 -0400
Message-ID: <4A4B9BA1.6040109@redhat.com>
Date: Wed, 01 Jul 2009 13:23:45 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH v2] Show kernel stack usage to /proc/meminfo and OOM log
References: <20090701103622.85CD.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0906301011210.6124@gentwo.org> <20090701082531.85C2.A69D9226@jp.fujitsu.com> <10604.1246459458@redhat.com> <alpine.DEB.1.10.0907011315540.9522@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907011315540.9522@gentwo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 1 Jul 2009, David Howells wrote:
> 
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>>> +	int pages = THREAD_SIZE / PAGE_SIZE;
>> Bad assumption.  On FRV, for example, THREAD_SIZE is 8K and PAGE_SIZE is 16K.
> 
> Guess that means we need arch specific accounting for this counter.

Or we count the number of stacks internally and only
convert to pages whenever we display the value.

-- 
All rights reversed.
