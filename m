Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYFXRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYFXRLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbYFXRLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:11:07 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22668 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbYFXRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:11:05 -0400
Subject: Re: [RFC][PATCH] putback_lru_page()/unevictable page handling
	rework v3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 24 Jun 2008 13:10:53 -0400
Message-Id: <1214327453.6563.14.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 11:43 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > I merged kamezawa-san's SHMEM related fix.
> > this patch works well >2H.
> > and, I am going to test on stress workload during this week end.
> > 
> > but I hope recieve review at first.
> > thus I post it now.
> 
> Unfortunately, my machine crashed last night ;-)
> I'll dig it.


I ran 26-rc5-mm3 with 5 split/unevictable lru patches that you posted on
19june.  I replaced patch 5 of that series with the subject patch
[rework v3, merged SHMEM fix].  This kernel ran my 'usex' stress load
overnight for 23+ hours on both ia64 and x86_64 platforms with no
problems.  I evidently did not hit the problem you did.

I'm rebuilding with a patch to a small problem that I discovered along
with your recent patch to "prevent incorrect oom...".  I'll let you know
how that goes as well.

I'll send along two additional patches shortly.

Lee

