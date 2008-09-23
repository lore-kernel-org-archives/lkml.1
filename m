Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbYIWMQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbYIWMQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYIWMP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:15:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50696 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYIWMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:15:59 -0400
Date: Tue, 23 Sep 2008 21:15:33 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <1222102098.8533.62.camel@nimitz>
References: <20080922162152.GB7716@csn.ul.ie> <1222102098.8533.62.camel@nimitz>
Message-Id: <20080923211140.DC16.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The corollary is that someone running with a 64K base page kernel may be
> > surprised that the pagesize is always 4K. However I'll check if there is
> > a simple way of checking out if the MMU size differs from PAGE_SIZE.
> 
> Sure.  If it isn't easy, the best thing to do is probably just to
> document the "interesting" behavior.

Dave, please let me know getpagesize() function return to 4k or 64k on ppc64.
I think the PageSize line of the /proc/pid/smap and getpagesize() result should be matched.

otherwise, enduser may be confused.



