Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZESNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZESNZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZESNZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:25:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbZESNZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:25:24 -0400
Message-ID: <4A12B30D.9040002@redhat.com>
Date: Tue, 19 May 2009 09:24:29 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first	class
 citizen
References: <20090519161756.4EE4.A69D9226@jp.fujitsu.com> <20090519074925.GA690@localhost> <20090519170208.742C.A69D9226@jp.fujitsu.com> <20090519085354.GB2121@localhost>
In-Reply-To: <20090519085354.GB2121@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> Another (amazing) finding of the test is, only around 1/10 mapped pages
> are actively referenced in the absence of user activities.
> 
> Shall we protect the remaining 9/10 inactive ones? This is a question ;-)

I believe we already do, due to the active list not being
scanned if none of the streaming IO pages get promoted to
the active list.

-- 
All rights reversed.
