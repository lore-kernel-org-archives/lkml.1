Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZIGXyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZIGXyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZIGXyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:54:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43801 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZIGXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:54:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 8 Sep 2009 08:52:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm: around get_user_pages flags
Message-Id: <20090908085225.388ce122.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009 22:26:51 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Here's a series of mm mods against current mmotm: mostly cleanup
> of get_user_pages flags, but fixing munlock's OOM, sorting out the
> "FOLL_ANON optimization", and reinstating ZERO_PAGE along the way.
> 
>  fs/binfmt_elf.c         |   42 ++------
>  fs/binfmt_elf_fdpic.c   |   56 ++++-------
>  include/linux/hugetlb.h |    4 
>  include/linux/mm.h      |    4 
>  mm/hugetlb.c            |   62 +++++++------
>  mm/internal.h           |    7 -
>  mm/memory.c             |  180 +++++++++++++++++++++++---------------
>  mm/mlock.c              |   99 ++++++++------------
>  mm/nommu.c              |   22 ++--
>  9 files changed, 235 insertions(+), 241 deletions(-)
> 
> Hugh
> 
Seems much claerer than mine. I'll test.
Thank you very much.

Regards,
-Kame

