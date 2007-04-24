Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXDXJ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXDXJ7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 05:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161532AbXDXJ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 05:59:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50190 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXDXJ7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 05:59:40 -0400
Date: Tue, 24 Apr 2007 18:58:57 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Cc: Andrew Morton <akpm@linux-foundation.org>, tony.luck@intel.com,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070423183637.GA11982@skynet.ie>
References: <20070423183246.GA11841@skynet.ie> <20070423183637.GA11982@skynet.ie>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070424183847.FD98.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> Subject: Check zone boundaries when freeing bootmem
> Zone boundaries do not have to be aligned to MAX_ORDER_NR_PAGES. 

Hmm. I don't understand here yet... Could you explain more? 

This issue occurs only when ZONE_MOVABLE is specified.
If its boundary is aligned to MAX_ORDER automatically,
I guess user will not mind it.

>From memory hotplug view, I prefer section size alignment to make
simple code. :-P


> However,
> during boot, there is an implicit assumption that they are aligned to a
> BITS_PER_LONG boundary when freeing pages as quickly as possible. This
> patch checks the zone boundaries when freeing pages from the bootmem allocator.

Anyway, the patch works well.

Bye.

-- 
Yasunori Goto 


