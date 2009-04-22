Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZDVBAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZDVBAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 21:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZDVBAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 21:00:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34158 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZDVBAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 21:00:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: [Patch] mm tracepoints update
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com, mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <1240353915.11613.39.camel@dhcp-100-19-198.bos.redhat.com>
References: <1240353915.11613.39.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20090422095916.627A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 22 Apr 2009 10:00:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I've cleaned up the mm tracepoints to track page allocation and
> freeing, various types of pagefaults and unmaps, and critical page
> reclamation routines.  This is useful for debugging memory allocation
> issues and system performance problems under heavy memory loads.

In past thread, Andrew pointed out bare page tracer isn't useful.
Can you make good consumer?


> 
> 
> ----------------------------------------------------------------------
> 
> 
> # tracer: mm
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>          pdflush-624   [004]   184.293169: wb_kupdate:
> mm_pdflush_kupdate count=3e48
>          pdflush-624   [004]   184.293439: get_page_from_freelist:
> mm_page_allocation pfn=447c27 zone_free=1940910
>         events/6-33    [006]   184.962879: free_hot_cold_page:
> mm_page_free pfn=44bba9
>       irqbalance-8313  [001]   188.042951: unmap_vmas:
> mm_anon_userfree mm=ffff88044a7300c0 address=7f9a2eb70000 pfn=24c29a
>              cat-9122  [005]   191.141173: filemap_fault:
> mm_filemap_fault primary fault: mm=ffff88024c9d8f40 address=3cea2dd000
> pfn=44d68e
>              cat-9122  [001]   191.143036: handle_mm_fault:
> mm_anon_fault mm=ffff88024c8beb40 address=7fffbde99f94 pfn=24ce22
> -------------------------------------------------------------------------
> 
> Signed-off-by: Larry Woodman <lwoodman@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> 
> 
> The patch applies to ingo's latest tip tree:



