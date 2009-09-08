Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbZIHTAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbZIHTAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZIHTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZIHTAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:00:14 -0400
Message-ID: <4AA6A989.60907@redhat.com>
Date: Tue, 08 Sep 2009 14:59:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm: FOLL_DUMP replace FOLL_ANON
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072233240.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072233240.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> The "FOLL_ANON optimization" and its use_zero_page() test have caused
> confusion and bugs: why does it test VM_SHARED? for the very good but
> unsatisfying reason that VMware crashed without.  As we look to maybe
> reinstating anonymous use of the ZERO_PAGE, we need to sort this out.
> 
> Easily done: it's silly for __get_user_pages() and follow_page() to
> be guessing whether it's safe to assume that they're being used for
> a coredump (which can take a shortcut snapshot where other uses must
> handle a fault) - just tell them with GUP_FLAGS_DUMP and FOLL_DUMP.
> 
> get_dump_page() doesn't even want a ZERO_PAGE: an error suits fine.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
