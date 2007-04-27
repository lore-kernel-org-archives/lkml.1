Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXD0BuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXD0BuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXD0Bto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:49:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46542 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbXD0Btn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:49:43 -0400
Date: Fri, 27 Apr 2007 10:50:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] change global zonelist order on NUMA v2
Message-Id: <20070427105005.9e2e2cc0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704261824340.23914@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
	<200704261147.44413.ak@suse.de>
	<20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
	<20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0704261824340.23914@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 18:25:10 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 27 Apr 2007, KAMEZAWA Hiroyuki wrote:
> 
> > > DMA memory.
> > > 
> > It seems a bit complicated. If we do so, following can occur,
> > 
> > Node1: cpu0,1,2,3
> > Node0: cpu4,5,6,7
> 
> We were discussing a two node NUMA system. If you have more put it onto 
> the last.
> 
Hmm, from technical point of view, renumbering may be an option.
But I feel that it's not natural look and different from user's expectation...

-Kame

