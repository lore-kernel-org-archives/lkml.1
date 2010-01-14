Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953Ab0ANFS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0ANFS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411Ab0ANFS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:18:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56318 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0ANFSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:18:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <28c262361001132112i7f50fd66qcd24dc2ddb4d78d8@mail.gmail.com>
References: <20100114084659.D713.A69D9226@jp.fujitsu.com> <28c262361001132112i7f50fd66qcd24dc2ddb4d78d8@mail.gmail.com>
Message-Id: <20100114141735.672B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 14:18:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well. zone->lock and zone->lru_lock should be not taked at the same time.
> 
> I looked over the code since I am out of office.
> I can't find any locking problem zone->lock and zone->lru_lock.
> Do you know any locking order problem?
> Could you explain it with call graph if you don't mind?
> 
> I am out of office by tomorrow so I can't reply quickly.
> Sorry for late reponse.

This is not lock order issue. both zone->lock and zone->lru_lock are
hotpath lock. then, same tame grabbing might cause performance impact.

thanks.



