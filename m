Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZEGPIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZEGPIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZEGPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:07:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59788 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZEGPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:07:52 -0400
Message-ID: <4A02F8ED.3090008@redhat.com>
Date: Thu, 07 May 2009 11:06:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
 citizen
References: <20090430072057.GA4663@eskimo.com>  <20090430174536.d0f438dd.akpm@linux-foundation.org>  <20090430205936.0f8b29fc@riellaptop.surriel.com>  <20090430181340.6f07421d.akpm@linux-foundation.org>  <20090430215034.4748e615@riellaptop.surriel.com>  <20090430195439.e02edc26.akpm@linux-foundation.org>  <49FB01C1.6050204@redhat.com>  <20090501123541.7983a8ae.akpm@linux-foundation.org>  <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>  <20090507121101.GB20934@localhost>  <alpine.DEB.1.10.0905070935530.24528@qirst.com> <1241705702.11251.156.camel@twins> <alpine.DEB.1.10.0905071016410.24528@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0905071016410.24528@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
>
>   
>> It re-instates the young bit for PROT_EXEC pages, so that they will only
>> be paged when they are really cold, or there is severe pressure.
>>     
>
> But they are rescanned until then. Really cold means what exactly? I do a
> back up of a few hundred gigabytes and do not use firefox while the backup
> is ongoing. Will the firefox pages still be in memory or not?
>   
The patch with the subject "[PATCH] vmscan: evict use-once pages first (v3)"
together with this patch should make sure that it stays in memory.
