Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZESNPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZESNPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZESNPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:15:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38095 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZESNPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:15:33 -0400
Message-ID: <4A12B0D1.1070803@redhat.com>
Date: Tue, 19 May 2009 09:14:57 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class
 	citizen
References: <20090516090005.916779788@intel.com>	 <20090516090448.410032840@intel.com> <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
In-Reply-To: <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

> Why do we need to skip JIT'd code? There are plenty of desktop
> applications that use Mono, for example, and it would be nice if we
> gave them the same treatment as native applications. Likewise, I am
> sure all browsers that use JIT for JavaScript need to be considered.

JIT'd code lives in anonymous pages, which are already
protected from streaming file IO because they live on
the anonymous LRUs.

-- 
All rights reversed.
