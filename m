Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYB0FSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYB0FSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYB0FSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:18:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51440 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYB0FSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:18:09 -0500
Date: Wed, 27 Feb 2008 14:13:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <47C4EF2D.90508@linux.vnet.ibm.com>
References: <20080227140221.424C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <47C4EF2D.90508@linux.vnet.ibm.com>
Message-Id: <20080227141227.424F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi balbir-san,

> >> CONFIG_SIMULTANEOUS_PAGE_RECLAIMERS 
> >> int
> >> default 3
> >> depends on DEBUG
> >> help
> >>   This value determines the number of threads which can do page reclaim
> >>   in a zone simultaneously. If this is too big, performance under heavy memory
> >>   pressure will decrease.
> >>   If unsure, use default.
> >> ==
> >>
> >> Then, you can get performance reports from people interested in this
> >> feature in test cycle.
> > 
> > hm, intersting.
> > but sysctl parameter is more better, i think.
> > 
> > OK, I'll add it at next post.
> 
> I think sysctl should be interesting. The config option provides good
> documentation, but it is static in nature (requires reboot to change). I wish we
> could have the best of both worlds.

OK, I obey your opinion.


- kosaki


