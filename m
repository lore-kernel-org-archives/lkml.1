Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab0BQPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 10:47:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab0BQPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 10:46:58 -0500
Message-ID: <4B7C0F2A.3020905@redhat.com>
Date: Wed, 17 Feb 2010 10:45:46 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 05/12] Memory compaction core
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-6-git-send-email-mel@csn.ul.ie> <20100216170014.7309.A69D9226@jp.fujitsu.com> <20100217132952.GA1663@csn.ul.ie>
In-Reply-To: <20100217132952.GA1663@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 08:29 AM, Mel Gorman wrote:

> Fix concerns from Kosaki Motohiro (merge with compaction core)
>
> o Fewer pages are isolated. Hence, cc->migrate_pfn in
>    isolate_migratepages() is updated slightly differently and the debug
>    checks change
> o LRU lists are no longer rotated
> o NR_ISOLATED_* is updated
> o del_page_from_lru_list() is used instead list_move when isolated so
>    that the counters get updated correctly.
> o Pages that fail to migrate are put back on the LRU promptly to avoid
>    being isolated for too long.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

Consider this an ack to your patch 5/12 with these fixes.

-- 
All rights reversed.
