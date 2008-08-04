Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYHDOH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYHDOH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHDOHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:07:10 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:37010 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbYHDOHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:07:08 -0400
X-IronPort-AV: E=Sophos;i="4.31,304,1215388800"; 
   d="scan'208";a="92275428"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl>
	<20080804131012.246115111@chello.nl>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 04 Aug 2008 07:07:06 -0700
In-Reply-To: <20080804131012.246115111@chello.nl> (Peter Zijlstra's message of
	"Mon, 04 Aug 2008 15:03:24 +0200")
Message-ID: <ada63qgvppx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Aug 2008 14:07:07.0204 (UTC) FILETIME=[61109840:01C8F63B]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > NOTE: we're still bound to the MAX_LOCK_DEPTH (48) limit.

A) It is probably a good idea to put this in a comment somewhere near
   where spin_lock_nest_lock() is declared.

B) It is probably a good idea to write that comment in such a way that
   dumb people like me understand what the limit is.  The sentence I
   quoted above is too telegraphic for me to get.  Is the point that no
   more than 48 spinlocks can be held at once, even if the inner locks
   are protected by some top level lock?  Or do you mean something else?

 - R.
