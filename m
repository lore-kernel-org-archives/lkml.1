Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZHDM7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZHDM7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZHDM7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:59:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36682 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbZHDM7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:59:49 -0400
Message-ID: <4A78319D.9030002@redhat.com>
Date: Tue, 04 Aug 2009 16:03:25 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 8/12] ksm: distribute remove_mm_from_lists
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031316180.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031316180.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Do some housekeeping in ksm.c, to help make the next patch easier
> to understand: remove the function remove_mm_from_lists, distributing
> its code to its callsites scan_get_next_rmap_item and __ksm_exit.
>
> That turns out to be a win in scan_get_next_rmap_item: move its
> remove_trailing_rmap_items and cursor advancement up, and it becomes
> simpler than before.  __ksm_exit becomes messier, but will change
> again; and moving its remove_trailing_rmap_items up lets us strengthen
> the unstable tree item's age condition in remove_rmap_item_from_tree.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>   
Acked-by: Izik Eidus <ieidus@redhat.com>
