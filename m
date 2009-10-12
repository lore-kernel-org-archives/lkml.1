Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZJLINR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZJLINR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZJLINQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:13:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40569 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZJLINP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:13:15 -0400
Date: Mon, 12 Oct 2009 17:12:32 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/2] vmscan: kill shrink_all_zones()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>
In-Reply-To: <200910112301.29237.rjw@sisk.pl>
References: <20091009175559.12B8.A69D9226@jp.fujitsu.com> <200910112301.29237.rjw@sisk.pl>
Message-Id: <20091012170439.E4CA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   Throuput comparision
> >   ==============================================
> >   old		2192.10 MB/s
> >   new		2222.22 MB/s
> > 
> >   ok, it's almost same throuput.
> > 
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> I have no objections to any of the two patches, but I think we may want to drop
> shrink_all_memory() altogether.  Everything should work without it and the
> reason I didn't remove it was because I saw a performance regression on one
> system without it.  It may not be worth keeping it, though.
> 
> Have you done any tests with shrink_all_memory() removed?

Honestly, I haven't try to remvoe shrink_all_memory() at all. then, I don't have any
mesurement data of shrink_all_memory.
Yes, your opinion seems reasonable. I plan to mesure it awhile after. (sorry, I haven't
enough development time in this month)



