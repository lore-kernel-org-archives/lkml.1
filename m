Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZKKBWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZKKBWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 20:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZKKBWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 20:22:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48053 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZKKBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 20:22:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 3/6] mm: CONFIG_MMU for PG_mlocked
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911102155180.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> <Pine.LNX.4.64.0911102155180.2816@sister.anvils>
Message-Id: <20091111101315.FD33.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 10:22:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove three degrees of obfuscation, left over from when we had
> CONFIG_UNEVICTABLE_LRU.  MLOCK_PAGES is CONFIG_HAVE_MLOCKED_PAGE_BIT
> is CONFIG_HAVE_MLOCK is CONFIG_MMU.  rmap.o (and memory-failure.o)
> are only built when CONFIG_MMU, so don't need such conditions at all.
> 
> Somehow, I feel no compulsion to remove the CONFIG_HAVE_MLOCK*
> lines from 169 defconfigs: leave those to evolve in due course.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I don't recall why Lee added this config option. but it seems very
reasonable and I storongly like it.

At least, vmscan folks never said "please try to disable CONFIG_MLOCK".
It mean this option didn't help our debug.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



