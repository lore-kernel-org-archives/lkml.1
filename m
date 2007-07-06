Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbXGFWk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbXGFWk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXGFWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:40:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41932 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756437AbXGFWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:40:18 -0400
Date: Fri, 6 Jul 2007 15:40:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, mel@csn.ul.ie
Subject: Re: [PATCH] memory unplug v7 - introduction
In-Reply-To: <20070706153401.d1d6bf88.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707061539330.26003@schroedinger.engr.sgi.com>
References: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
 <20070706153401.d1d6bf88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Andrew Morton wrote:

> On Fri, 6 Jul 2007 18:19:03 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > This is a memory unplug base patch set against 2.6.22-rc6-mm1.
> 
> Well I stuck these in -mm, but I don't know what they do.  An overall
> description of the design would make any review much more effective.
> 
> ie: what does it all do, and how does it do it?

The two patches that you just merged and that I acked are also 
generally useful for page migration. They are also necessary for
Mel's memory compaction patchset. 
