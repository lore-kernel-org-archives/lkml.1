Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXEGNJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXEGNJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933771AbXEGNJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:09:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36697 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933766AbXEGNJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:09:00 -0400
Date: Mon, 07 May 2007 22:07:36 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Subject: Re: fragmentation avoidance Re: 2.6.22 -mm merge plans
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, apw@shadowen.org, clameter@sgi.com
In-Reply-To: <20070501101651.GA29957@skynet.ie>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501101651.GA29957@skynet.ie>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070507211327.3129.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for late response. I went on a vacation in last week.
And I'm in the mountain of a ton of unread mail now....

> > Mel's moveable-zone work.
> 
> These patches are what creates ZONE_MOVABLE. The last 6 patches should be
> collapsed into a single patch:
> 
> 	handle-kernelcore=-generic
> 
> I believe Yasunori Goto is looking at these from the perspective of memory
> hot-remove and has caught a few bugs in the past. Goto-san may be able to
> comment on whether they have been reviewed recently.

Hmm, I don't think my review is enough.
To be precise, I'm just one user/tester of ZONE_MOVABLE.
I have tried to make memory remove patches with Mel-san's
ZONE_MOVABLE patch. And the bugs are things that I found in its work.
(I'll post these patches in a few days.)

> The main complexity is in one function in patch one which determines where
> the PFN is in each node for ZONE_MOVABLE. Getting that right so that the
> requested amount of kernel memory spread as evenly as possible is just
> not straight-forward.

>From memory-hotplug view, ZONE_MOVABLE should be aligned by section
size. But MAX_ORDER alignment is enough for others...

Bye.

-- 
Yasunori Goto 


