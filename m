Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZEQAf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZEQAf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 20:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZEQAfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 20:35:09 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:7899 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZEQAfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 20:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wwTemLCROWhUHjIkjJ/8uhfPNSK74qGKKERzo637/HiRfXGE9y1P8Ib7fqShYHVZS8
         5br69YMtGRKHlxPAqmHQJo7K0NLQzKfdzNmgTA59Xnl8sV1k6IDpoaWafenXyTUKUDLm
         65wNpOc/Hs3GEgqlFKFzXQK3NxN3WlgPF2nhs=
MIME-Version: 1.0
In-Reply-To: <20090516090448.249602749@intel.com>
References: <20090516090005.916779788@intel.com>
	 <20090516090448.249602749@intel.com>
Date: Sun, 17 May 2009 09:35:06 +0900
Message-ID: <28c262360905161735s291fc34ah845eb5f82e1ada25@mail.gmail.com>
Subject: Re: [PATCH 1/3] vmscan: report vm_flags in page_referenced()
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 6:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Collect vma->vm_flags of the VMAs that actually referenced the page.
>
> This is preparing for more informed reclaim heuristics,
> eg. to protect executable file pages more aggressively.
> For now only the VM_EXEC bit will be used by the caller.
>
> CC: Minchan Kim <minchan.kim@gmail.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
