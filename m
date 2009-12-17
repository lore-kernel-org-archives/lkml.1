Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbZLQAei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbZLQAei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763364AbZLQAef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:34:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56203 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762878AbZLQAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:34:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] mm: introduce dump_page() and print symbolic flag names
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Mel Gorman <mel@csn.ul.ie>, Alex Chiang <achiang@hp.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20091216152856.GB2804@hack>
References: <20091216122640.GA13817@localhost> <20091216152856.GB2804@hack>
Message-Id: <20091217092720.7ACC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Dec 2009 09:34:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Dec 16, 2009 at 08:26:40PM +0800, Wu Fengguang wrote:
> >- introduce dump_page() to print the page info for debugging some error condition.
> 
> Since it is for debugging, shouldn't it be surrounded by
> CONFIG_DEBUG_VM too? :-/

No.
typically, wrong driver makes bad_page() calling and MM developer suggested
how to fix in lkml. then, MM developer hope it is enabled on end user's
machine.

Thanks.


