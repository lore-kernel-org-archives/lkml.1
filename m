Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZEQBYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZEQBYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZEQBYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:24:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:20430 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbZEQBYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Awo8ZVPuUTX4xkAUG3R99ArkioxWTKVAUjNalRnHSBNU/97wEqVNC7HCceKGwO9Xum
         OlDBmfrFYjGzeIzj4blX+GUIFQG2751jqPABjxBdairHRMSx68uRWSQywdB5cZwOUOdE
         zFvLy9ILxQkNfXCDy7bowdwlZzBQXAdGbiySA=
MIME-Version: 1.0
In-Reply-To: <20090516090448.535217680@intel.com>
References: <20090516090005.916779788@intel.com>
	 <20090516090448.535217680@intel.com>
Date: Sun, 17 May 2009 10:24:13 +0900
Message-ID: <28c262360905161824p7022748esb0f8600a8317eab9@mail.gmail.com>
Subject: Re: [PATCH 3/3] vmscan: merge duplicate code in shrink_active_list()
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 6:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> The "move pages to active list" and "move pages to inactive list"
> code blocks are mostly identical and can be served by a function.
>
> Thanks to Andrew Morton for pointing this out.
>
> Note that buffer_heads_over_limit check will also be carried out
> for re-activated pages, which is slightly different from pre-2.6.28
> kernels. Also, Rik's "vmscan: evict use-once pages first" patch
> could totally stop scans of active list when memory pressure is low.

To clarify, active file list. otherwise is good to me.
Thanks for your great effort to enhance VM. :)

> CC: Rik van Riel <riel@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
Minchan Kim
