Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbXEKAxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbXEKAxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbXEKAxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:53:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37060 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761220AbXEKAxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:53:03 -0400
Date: Fri, 11 May 2007 09:53:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: y-goto@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@osdl.org, clameter@sgi.com
Subject: Re: [RFC] memory hotremove patch take 2 [03/10] (drain all pages)
Message-Id: <20070511095321.6559932c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705101634350.3786@skynet.skynet.ie>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120337.B90A.Y-GOTO@jp.fujitsu.com>
	<Pine.LNX.4.64.0705101634350.3786@skynet.skynet.ie>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:35:37 +0100 (IST)
Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, 9 May 2007, Yasunori Goto wrote:
> 
> > This patch add function drain_all_pages(void) to drain all
> > pages on per-cpu-freelist.
> > Page isolation will catch them in free_one_page.
> >
> 
> Is this significantly different to what drain_all_local_pages() currently 
> does?
> 

no difference. this duplicating it..... thank you for pointing out.
Maybe I missed this because this func only exists in -mm.

Regards,
-Kame

