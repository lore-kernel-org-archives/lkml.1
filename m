Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbZL2OJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbZL2OJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZL2OJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:09:22 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37778 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZL2OJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:09:22 -0500
Date: Tue, 29 Dec 2009 19:38:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/4] vmstat: add anon_scan_ratio field to zoneinfo
Message-ID: <20091229140825.GQ3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
 <20091228164816.A68D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091228164816.A68D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-12-28 16:48:51]:

> Vmscan folks was asked "why does my system makes so much swap-out?"
> in lkml at several times.
> At that time, I made the debug patch to show recent_anon_{scanned/rorated}
> parameter at least three times.
> 
> Thus, its parameter should be showed on /proc/zoneinfo. It help
> vmscan folks debugging.
>

Hmmm.. I think this should come under DEBUG_VM, a lot of tools use
/proc/zoneinfo, the additional overhead may be high.. no? Also,
I would recommend adding the additional details to the end, so
as to not break existing tools (specifically dump line # based
tools).
 
-- 
	Balbir
