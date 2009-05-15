Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZEOTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZEOTu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZEOTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:50:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:33335 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbZEOTuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:50:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,200,1241420400"; 
   d="scan'208";a="515944999"
Message-ID: <4A0DC797.7040502@linux.intel.com>
Date: Fri, 15 May 2009 21:50:47 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Campbell <ian.campbell@citrix.com>, Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com> <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [ Jakub - I added you to the participants list because it really looks 
>   like this patch (without 'noinline') triggers a gcc bug.

This whole thing seems to be much more problematic than I originally thought :-/

Maybe it's better to just give up on gcc 3.2 instead and forbid it and revert
my original patch. That would have the advantage that we wouldn't need
to worry about the inline heuristics on that old compiler too (that was
the reason I even tested it)

Given the smaller code size was a nice bonus, but it wasn't a big difference.

-Andi


