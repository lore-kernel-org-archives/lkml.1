Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZGIFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZGIFuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZGIFuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:50:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56064 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZGIFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:50:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0907071252060.5124@gentwo.org>
References: <28c262360907050827y577c3859g5e05e82935e96010@mail.gmail.com> <alpine.DEB.1.10.0907071252060.5124@gentwo.org>
Message-Id: <20090709144938.23A8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 14:50:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 6 Jul 2009, Minchan Kim wrote:
> 
> > Anyway, I think it's not a big cost in normal system.
> > So If you want to add new accounting, I don't have any objection. :)
> 
> Lets keep the counters to a mininum. If we can calculate the values from
> something else then there is no justification for a new counter.
> 
> A new counter increases the size of the per cpu structures that exist for
> each zone and each cpu. 1 byte gets multiplies by the number of cpus and
> that gets multiplied by the number of zones.

OK. I'll implement this idea.



