Return-Path: <linux-kernel-owner+w=401wt.eu-S936364AbZLQEN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936364AbZLQEN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936354AbZLQENi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:13:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41914 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936184AbZLQEMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:12:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
In-Reply-To: <1261004515.21028.510.camel@laptop>
References: <alpine.DEB.2.00.0912161025290.8572@router.home> <1261004515.21028.510.camel@laptop>
Message-Id: <20091217130945.9F9A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Dec 2009 13:11:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for per-vma locks, those are pretty much useless too, there's plenty
> applications doing lots of work on a few very large vmas.

Yes, because brk() makes large vmas. I don't imazine no malloc application
are so much.


