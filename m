Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXD0BZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXD0BZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbXD0BZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:25:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48603 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755319AbXD0BZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:25:12 -0400
Date: Thu, 26 Apr 2007 18:25:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: ak@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] change global zonelist order on NUMA v2
In-Reply-To: <20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0704261824340.23914@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
 <200704261147.44413.ak@suse.de> <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
 <20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, KAMEZAWA Hiroyuki wrote:

> > DMA memory.
> > 
> It seems a bit complicated. If we do so, following can occur,
> 
> Node1: cpu0,1,2,3
> Node0: cpu4,5,6,7

We were discussing a two node NUMA system. If you have more put it onto 
the last.
