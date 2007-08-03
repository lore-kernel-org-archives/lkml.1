Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbXHCATR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbXHCATR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 20:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759246AbXHCATB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 20:19:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42736 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbXHCAS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 20:18:59 -0400
Date: Fri, 3 Aug 2007 09:19:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/migrate.c: cleanups
Message-Id: <20070803091939.233f296f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0708021142240.7682@schroedinger.engr.sgi.com>
References: <20070729150320.GF16817@stusta.de>
	<20070802191502.B7A6.Y-GOTO@jp.fujitsu.com>
	<Pine.LNX.4.64.0708021142240.7682@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 11:43:21 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 2 Aug 2007, Yasunori Goto wrote:
> 
> > But, this patch is the cause of compile error of memory unplug code of
> > 2.6.23-rc1-mm2. It uses putback_lru_pages(). 
> > Don't make it static please... :-(
> 
> Right. But Adrian insisted since it was currently not used upstream.
> 
> So I guess you will have to revert this piece in your unplug code.
> 
Okay, I'll take are.
But I'm too busy in these days.

Andrew, If you have to drop unplug patch set, please do.
I'll rework all when I find time.

Thanks,
-Kame

