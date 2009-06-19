Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZFSJFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZFSJFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZFSJFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:05:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZFSJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:05:40 -0400
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
 citizen
From: Peter Zijlstra <peterz@infradead.org>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "Wang, Roger" <roger.wang@intel.com>
In-Reply-To: <20090619090011.GA30561@localhost>
References: <20090516090005.916779788@intel.com>
	 <1242485776.32543.834.camel@laptop> <20090617141135.0d622bfe@jbarnes-g45>
	 <20090618012532.GB19732@localhost>  <20090619090011.GA30561@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Jun 2009 11:04:49 +0200
Message-Id: <1245402289.13761.24606.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 17:00 +0800, Wu, Fengguang wrote:
> [add CC]
> 
> This OOM case looks like the same bug encountered by David Howells.
> 
> > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426766] Active_anon:290797 active_file:28 inactive_anon:97034
> > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426767]  inactive_file:61 unevictable:11322 dirty:0 writeback:0 unstable:0
> > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426768]  free:3341 slab:13776 mapped:5880 pagetables:6851 bounce:0
> 
> active/inactive_anon pages take up 4/5 memory.  Are you using TMPFS a lot?

I suspect its his GEM thingy ;-)


