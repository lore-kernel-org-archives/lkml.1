Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYHDS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYHDS44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbYHDS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:56:45 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:47932 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496AbYHDS4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:56:44 -0400
X-IronPort-AV: E=Sophos;i="4.31,306,1215388800"; 
   d="scan'208";a="92393062"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by mm_take_all_locks
References: <ada63qgvppx.fsf@cisco.com> <1217859571.3589.7.camel@twins>
	<aday73cua99.fsf@cisco.com> <1217860332.3589.11.camel@twins>
	<20080804145318.GA17867@redhat.com> <1217861763.3589.13.camel@twins>
	<20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins>
	<20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 04 Aug 2008 11:56:38 -0700
In-Reply-To: <1217875739.3589.56.camel@twins> (Peter Zijlstra's message of
	"Mon, 04 Aug 2008 20:48:59 +0200")
Message-ID: <adazlnssj6h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Aug 2008 18:56:38.0707 (UTC) FILETIME=[D3499830:01C8F663]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > NAK, come-on, you didn't even bother to look at the available
 > annotations..

Agree that this trylock-in-a-loop is a horrible hack that should never
be merged.

However I wonder what you think the right way to annotate the
potentially unbounded number of locks taken in mm_take_all_locks() is?

 - R.
