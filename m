Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZHCQDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZHCQDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZHCQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:03:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40850 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbZHCQDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:03:02 -0400
Message-ID: <4A7709A0.4060402@redhat.com>
Date: Mon, 03 Aug 2009 19:00:32 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/12] ksm: break cow once unshared
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031311590.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031311590.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> We kept agreeing not to bother about the unswappable shared KSM pages
> which later become unshared by others: observation suggests they're not
> a significant proportion.  But they are disadvantageous, and it is easier
> to break COW to replace them by swappable pages, than offer statistics
> to show that they don't matter; then we can stop worrying about them.
>
> Doing this in ksm_do_scan, they don't go through cmp_and_merge_page on
> this pass: give them a good chance of getting into the unstable tree
> on the next pass, or back into the stable, by computing checksum now.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
ACK
