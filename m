Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYKPIL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYKPIL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYKPILu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:11:50 -0500
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:54796 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYKPILu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:11:50 -0500
Date: Sun, 16 Nov 2008 16:43:10 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20081114091828.48fc4b67.akpm@linux-foundation.org>
References: <491D8CEC.5050106@redhat.com> <20081114091828.48fc4b67.akpm@linux-foundation.org>
Message-Id: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Of course, one thing we could do is exempt kswapd from this check.
> > During light reclaim, kswapd does most of the eviction so scanning
> > should remain balanced.  Having one process fall down to a lower
> > priority level is also not a big problem.
> > 
> > As long as the direct reclaim processes do not also fall into the
> > same trap, the situation should be manageable.
> > 
> > Does that sound reasonable to you?
> 
> I'll need to find some time to go dig through the changelogs.  

as far as I tried, git database doesn't have that changelogs.
FWIW, I guess it is more old.




