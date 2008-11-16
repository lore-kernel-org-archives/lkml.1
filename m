Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYKPHyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYKPHyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:54:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbYKPHya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:54:30 -0500
Date: Sat, 15 Nov 2008 23:54:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after
 swap_cluster_max pages
Message-Id: <20081115235410.2d2c76de.akpm@linux-foundation.org>
In-Reply-To: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <491D8CEC.5050106@redhat.com>
	<20081114091828.48fc4b67.akpm@linux-foundation.org>
	<20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 16:43:10 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > Of course, one thing we could do is exempt kswapd from this check.
> > > During light reclaim, kswapd does most of the eviction so scanning
> > > should remain balanced.  Having one process fall down to a lower
> > > priority level is also not a big problem.
> > > 
> > > As long as the direct reclaim processes do not also fall into the
> > > same trap, the situation should be manageable.
> > > 
> > > Does that sound reasonable to you?
> > 
> > I'll need to find some time to go dig through the changelogs.  
> 
> as far as I tried, git database doesn't have that changelogs.
> FWIW, I guess it is more old.
> 

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git
goes back to 2.5.20 (iirc).

