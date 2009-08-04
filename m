Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZHDMhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZHDMhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZHDMhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:37:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54386 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZHDMhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:37:10 -0400
Message-ID: <4A782C61.4030809@redhat.com>
Date: Tue, 04 Aug 2009 15:41:05 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 6/12] ksm: five little cleanups
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031314070.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031314070.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> 1. We don't use __break_cow entry point now: merge it into break_cow.
> 2. remove_all_slot_rmap_items is just a special case of
>    remove_trailing_rmap_items: use the latter instead.
> 3. Extend comment on unmerge_ksm_pages and rmap_items.
> 4. try_to_merge_two_pages should use try_to_merge_with_ksm_page
>    instead of duplicating its code; and so swap them around.
> 5. Comment on cmp_and_merge_page described last year's: update it.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>
>   
Acked-by: Izik Eidus <ieidus@redhat.com>

