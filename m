Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYHDO0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYHDO0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYHDO02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:26:28 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:42245 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYHDO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:26:27 -0400
X-IronPort-AV: E=Sophos;i="4.31,304,1215388800"; 
   d="scan'208";a="61169469"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl>
	<20080804131012.246115111@chello.nl> <ada63qgvppx.fsf@cisco.com>
	<1217859571.3589.7.camel@twins>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 04 Aug 2008 07:26:26 -0700
In-Reply-To: <1217859571.3589.7.camel@twins> (Peter Zijlstra's message of
	"Mon, 04 Aug 2008 16:19:31 +0200")
Message-ID: <aday73cua99.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Aug 2008 14:26:26.0266 (UTC) FILETIME=[13EB6BA0:01C8F63E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > No more than 48 locks (mutexes, rwlocks, spinlock, RCU, everything
 > covered by lockdep) held by any one code-path; including nested
 > interrupt contexts.

Does that mean that something like the new mm_take_all_locks() operation
is going to explode if someone tries to use it with lockdep on?

 - R.
