Return-Path: <linux-kernel-owner+w=401wt.eu-S1031432AbXEDRgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031432AbXEDRgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031433AbXEDRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:36:13 -0400
Received: from outbound-mail-45.bluehost.com ([69.89.18.14]:41150 "HELO
	outbound-mail-45.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031432AbXEDRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:36:12 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] change global zonelist order v4 [0/2]
Date: Fri, 4 May 2007 10:36:01 -0700
User-Agent: KMail/1.9.6
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com> <1178299460.5236.35.camel@localhost> <Pine.LNX.4.64.0705041027030.22643@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705041027030.22643@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041036.01904.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2007, Christoph Lameter wrote:
> On Fri, 4 May 2007, Lee Schermerhorn wrote:
> > Hmmm...  "serious hackery", indeed!  ;-)
>
> Maybe on the arch level but minimal changes to core code.
> And it is a step towards avoiding zones in NUMA.

You mentioned that if node 0 has a small ZONE_NORMAL and the ZONE_DMA for 
the system, defaulting to using ZONE_NORMAL on all nodes first would be a 
bad idea.  Is that really true?  Maybe for ZONE_DMA32 it is since that 
first node could have a few gigs of memory, but for regular ZONE_DMA it's 
probably the right thing to do...

So aside from the comment issues Lee already pointed out, I think 
Kamezawa-san's patch from 
http://marc.info/?l=linux-mm&m=117758484122663&w=4 seems reasonable.

Jesse
