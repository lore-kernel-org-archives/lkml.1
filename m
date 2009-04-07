Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbZDGQEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbZDGQEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759167AbZDGQDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759156AbZDGQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:03:16 -0400
Date: Tue, 7 Apr 2009 08:50:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Levshin <lpk@581.spb.su>, wli@movementarian.org,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Mike Waychison <mikew@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rohit Seth <rohitseth@google.com>, Edwin <edwintorok@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/14] readahead: clean up and simplify the code for
 filemap page fault readahead
In-Reply-To: <20090407115234.998014232@intel.com>
Message-ID: <alpine.LFD.2.00.0904070849570.27889@localhost.localdomain>
References: <20090407115039.780820496@intel.com> <20090407115234.998014232@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Wu Fengguang wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> This shouldn't really change behavior all that much, but the single
> rather complex function with read-ahead inside a loop etc is broken up
> into more manageable pieces.

Heh. That's an old patch.

Anyway, ACK on the whole series (or at least the pieces of it that were 
cc'd to me). Looks like sane cleanups, and I don't mean just my own old 
patch ;)

		Linus
