Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbZBYVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbZBYVc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758599AbZBYVcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:32:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbZBYVcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:32:17 -0500
Message-ID: <49A5B8AE.3060701@redhat.com>
Date: Wed, 25 Feb 2009 16:31:26 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: don't free swap slots on page deactivation
References: <20090225023830.GA1611@cmpxchg.org> <20090225192550.GA5645@cmpxchg.org>
In-Reply-To: <20090225192550.GA5645@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> The pagevec_swap_free() at the end of shrink_active_list() was
> introduced in 68a22394 "vmscan: free swap space on swap-in/activation"
> when shrink_active_list() was still rotating referenced active pages.
> 
> In 7e9cd48 "vmscan: fix pagecache reclaim referenced bit check" this
> was changed, the rotating removed but the pagevec_swap_free() after
> the rotation loop was forgotten, applying now to the pagevec of the
> deactivation loop instead.
> 
> Now swap space is freed for deactivated pages.  And only for those
> that happen to be on the pagevec after the deactivation loop.
> 
> Complete 7e9cd48 and remove the rest of the swap freeing.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
