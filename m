Return-Path: <linux-kernel-owner+w=401wt.eu-S935138AbXEIA3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138AbXEIA3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXEIA3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:29:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35463 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXEIA3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:29:10 -0400
Date: Wed, 9 May 2007 09:29:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, ak@suse.de, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] change zonelist order v5 [1/3] implements zonelist
 order selection
Message-Id: <20070509092912.3140bb78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1178656627.5203.84.camel@localhost>
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
	<20070508201642.c63b3f65.kamezawa.hiroyu@jp.fujitsu.com>
	<1178643985.5203.27.camel@localhost>
	<Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>
	<1178645622.5203.53.camel@localhost>
	<Pine.LNX.4.64.0705081104180.9941@schroedinger.engr.sgi.com>
	<1178656627.5203.84.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 16:37:06 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> > You probably need a 
> > configuration with a couple of nodes. Maybesomething less symmetric than 
> > Kame? I.e. have 4GB nodes and then DMA32 takes out a sizeable chunk of it?
> > 
> 
> I tested on a 2 socket, 4GB Opteron blade.  All memory is either DMA32
> or DMA.  I added some ad hoc instrumentation to the build_zonelist_*
> functions to see what's happening.  I have verified that the patches
> appear to build the zonelists correctly:
> 
Thank you. good news.

-Kame

