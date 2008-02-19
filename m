Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbYBSHKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbYBSHKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYBSHK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:10:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48937 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbYBSHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:10:27 -0500
Date: Tue, 19 Feb 2008 16:09:07 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802191735.00222.nickpiggin@yahoo.com.au>
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com> <200802191735.00222.nickpiggin@yahoo.com.au>
Message-Id: <20080219160711.7E99.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

> Yeah this is definitely needed and a nice result.
> 
> I'm worried about a) placing a global limit on parallelism, and b)
> placing a limit on parallelism at all.

sorry, i don't understand yet.
a) and b) have any relation?

> 
> I think it should maybe be a per-zone thing...
> 
> What happens if you make it a per-zone mutex, and allow just a single
> process to reclaim pages from a given zone at a time? I guess that is
> going to slow down throughput a little bit in some cases though...

That makes sense.

OK.
I'll repost after 2-3 days.

Thanks.

- kosaki


