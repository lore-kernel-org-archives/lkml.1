Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZFYEe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZFYEe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZFYEet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:34:49 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:17744 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZFYEes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:34:48 -0400
X-IronPort-AV: E=Sophos;i="4.42,288,1243814400"; 
   d="scan'208";a="180174324"
From: Roland Dreier <rdreier@cisco.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
References: <1245760130.3776.6.camel@localhost.localdomain>
	<20090623195656.GC8777@elte.hu>
	<1245876060.3038.7.camel@localhost.localdomain>
	<alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
	<1245904175.3022.4.camel@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 24 Jun 2009 21:34:50 -0700
In-Reply-To: <1245904175.3022.4.camel@localhost.localdomain> (Jaswinder Singh
	Rajput's message of "Thu, 25 Jun 2009 09:59:35 +0530")
Message-ID: <ada7hz1lymt.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jun 2009 04:34:50.0345 (UTC) FILETIME=[46F47590:01C9F54E]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >   L1-data-Cache-Load-Reference                  [Hardware cache event]
 >   L1-instruction-Cache-Load-Reference           [Hardware cache event]

obvious place to start is to change "data-Cache" and "instruction-Cache"
to "dcache" and "icache" which are still easy to figure out without
needing to look anything up.  And "Reference" can become "ref" with
minimal loss of clarity too.  So we could get down to

    L1-icache-load
    L1-icache-load-miss
    L1-icache-store-miss
    L1-icache-prefetch
    L1-icache-prefetch-miss

and so on.

 >   Data-TLB-Cache-Load-Reference                 [Hardware cache event]

Could become

    dTLB-load
    dTLB-load-miss
    iTLB-load

etc.
