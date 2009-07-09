Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbZGIDMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbZGIDMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZGIDMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:12:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49785 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZGIDMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:12:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 1/2] vmscan don't isolate too many pages
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <28c262360907071639g4877b2c2w59a8eae8559557f7@mail.gmail.com>
References: <20090707184034.0C70.A69D9226@jp.fujitsu.com> <28c262360907071639g4877b2c2w59a8eae8559557f7@mail.gmail.com>
Message-Id: <20090709121123.2392.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 12:12:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + ? ? ? if (too_many_isolated(gfp_mask, zonelist, high_zoneidx, nodemask)) {
> 
> too_many_isolated(zonelist, high_zoneidx, nodemask)

Correct.
I forgot to quilt refresh before sending. sorry.



