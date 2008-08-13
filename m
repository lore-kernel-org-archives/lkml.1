Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbYHMBlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbYHMBlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHMBkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:40:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45379
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbYHMBkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:40:51 -0400
Date: Tue, 12 Aug 2008 18:40:52 -0700 (PDT)
Message-Id: <20080812.184052.193693538.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: console handover badness
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
	<20080811.233013.49328708.davem@davemloft.net>
	<Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 12 Aug 2008 21:11:53 -0400 (EDT)

> and then boot failure of 2.6.27-rc[12] because of bad memory 
> migratetype. Is this migratetype crash a known problem? --- the problem is 
> that starting with 2.6.27rc1, I'm getting crash with this backtrace:
> __list_add
> __free_pages_ok
> __free_pages
> __free_pages_bootmem
> __free_all_bootmem
> mem_init
> start_kernel_tlb_fixup_code
> --- the crash is due to migratetype == 5 in __free_one_page (inlined into 
> __free_pages_ok) and because there are only 5 migratettypes, it attempts 
> to add to a non-existent list.

Mikulas can you send me the .config you're using in 2.6.27 to trigger
this?

Thanks.
