Return-Path: <linux-kernel-owner+w=401wt.eu-S938878AbXHIFwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938878AbXHIFwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbXHIFwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:52:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39871 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbXHIFwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:52:33 -0400
Date: Thu, 9 Aug 2007 14:53:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, Zoltan.Menyhart@bull.net, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] flush icache before set_pte() on ia64 take9 [2/2] flush
 icache at set_pte
Message-Id: <20070809145343.d23fb55c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070808.220838.88002572.davem@davemloft.net>
References: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com>
	<20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20070808.220838.88002572.davem@davemloft.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 22:08:38 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> If this patch works I am very happy with it, since lazy_mmu_prot_update()
> is now completely gone as a result.
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 

Of course, this patch fixes SIGILL/nfs on Montecito.
At least, passed my test.


Thanks,
-Kame

