Return-Path: <linux-kernel-owner+w=401wt.eu-S1033142AbXEIBU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033142AbXEIBU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXEIBUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:20:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39193 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXEIBUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:20:20 -0400
Date: Wed, 9 May 2007 10:20:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ak@suse.de, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] change zonelist order v5 [1/3] implements zonelist
 order selection
Message-Id: <20070509102018.8aaf21ed.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070508175855.b126caf7.akpm@linux-foundation.org>
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
	<20070508201642.c63b3f65.kamezawa.hiroyu@jp.fujitsu.com>
	<1178643985.5203.27.camel@localhost>
	<Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>
	<1178645622.5203.53.camel@localhost>
	<Pine.LNX.4.64.0705081104180.9941@schroedinger.engr.sgi.com>
	<1178656627.5203.84.camel@localhost>
	<20070509092912.3140bb78.kamezawa.hiroyu@jp.fujitsu.com>
	<20070508175855.b126caf7.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 17:58:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 9 May 2007 09:29:12 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Tue, 08 May 2007 16:37:06 -0400
> > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > 
> > > > You probably need a 
> > > > configuration with a couple of nodes. Maybesomething less symmetric than 
> > > > Kame? I.e. have 4GB nodes and then DMA32 takes out a sizeable chunk of it?
> > > > 
> > > 
> > > I tested on a 2 socket, 4GB Opteron blade.  All memory is either DMA32
> > > or DMA.  I added some ad hoc instrumentation to the build_zonelist_*
> > > functions to see what's happening.  I have verified that the patches
> > > appear to build the zonelists correctly:
> > > 
> > Thank you. good news.
> > 
> 
> I'm still cowering in fear of these patches, btw.
> 
Hmm, the patches looks unclear ? 

> Please keep testing and sending them ;)
> 
Okay. but it seems I need other testers...

I wonder I should drop sysctl of this patch and just support boot option
in next version.

-Kame

