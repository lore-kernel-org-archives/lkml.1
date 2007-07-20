Return-Path: <linux-kernel-owner+w=401wt.eu-S939160AbXGTBuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939160AbXGTBuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762121AbXGTBu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:50:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51420 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761755AbXGTBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:50:28 -0400
X-Greylist: delayed 68075 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 21:50:28 EDT
Date: Fri, 20 Jul 2007 10:51:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, nickpiggin@yahoo.com.au,
       mike@stroyan.net, dmosberger@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
Message-Id: <20070720105123.e9bd9577.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <469F80E3.3040007@bull.net>
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
	<20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>
	<469F5372.7010703@bull.net>
	<20070719220118.73f40346.kamezawa.hiroyu@jp.fujitsu.com>
	<469F71E7.4050200@bull.net>
	<20070719235157.9715baff.kamezawa.hiroyu@jp.fujitsu.com>
	<469F80E3.3040007@bull.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 17:18:59 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> KAMEZAWA Hiroyuki wrote:
> 
> > Hmm...but the current code flushes the page. just do it in "lazy" way.
> > much difference ?
> 
> I agree the current code flushes the I-cache for all kinds of file
> systems (for PTEs with the exec bit on).
> 
> The error is that it does it after the PTE is written.
> 
> In addition, I wanted to optimize it to gain a few %.
I'm glad, too if we can do it. But it seems that we need a bit
clever way to do that.

> Apparently this idea is not much welcome.
> 
> I can agree that flushing the I-cache (if the architecture requires it)
> before setting the PTE eliminates the error.
> 
Hm, I'll refresh and repost the patch. 

Thanks,
-Kame

