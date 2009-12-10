Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbZLJHx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbZLJHx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbZLJHxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:53:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45048 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520AbZLJHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:53:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v2  0/8] vmscan: AIM7 scalability improvement 
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091210154822.2550.A69D9226@jp.fujitsu.com>
References: <20091210154822.2550.A69D9226@jp.fujitsu.com>
Message-Id: <20091210165208.256B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Dec 2009 16:53:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Larry Woodman reported current VM has big performance regression when
> AIM7 benchmark. It use very much processes and fork/exit/page-fault frequently.
> (i.e. it makes serious lock contention of ptelock and anon_vma-lock.)
> 
> At 2.6.28, we removed calc_reclaim_mapped() and it made vmscan, then
> vmscan always call page_referenced() although VM pressure is low.
> It increased lock contention more, unfortunately.
> 
> 
> Larry, can you please try this patch series on your big box?

this patches is made ontop mmotm1208.




