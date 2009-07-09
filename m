Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZGIGje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZGIGje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZGIGj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:39:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52771 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZGIGjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:39:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 1/2] vmscan don't isolate too many pages in a zone
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20090708215105.5016c929@bree.surriel.com>
References: <20090708031901.GA9924@localhost> <20090708215105.5016c929@bree.surriel.com>
Message-Id: <20090709153753.23AD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 15:39:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> When way too many processes go into direct reclaim, it is possible
> for all of the pages to be taken off the LRU.  One result of this
> is that the next process in the page reclaim code thinks there are
> no reclaimable pages left and triggers an out of memory kill.
> 
> One solution to this problem is to never let so many processes into
> the page reclaim path that the entire LRU is emptied.  Limiting the
> system to only having half of each inactive list isolated for
> reclaim should be safe.

Thanks good patch.
I'd like to run several benchmark and compare my and your patches.

Can you please gime me few days?



