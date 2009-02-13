Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbZBMGPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbZBMGPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 01:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761636AbZBMGPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 01:15:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47551 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761616AbZBMGPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 01:15:21 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] fix memmap init for handling memory hole
Cc: kosaki.motohiro@jp.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       davem@davemlloft.net, heiko.carstens@de.ibm.com,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20090212162421.65bb7aa2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com> <20090212162421.65bb7aa2.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090213151455.77CE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Feb 2009 15:15:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, early_pfn_in_nid(PFN, NID) may returns false if PFN is a hole.
> and memmap initialization was not done. This was a trouble for
> sparc boot.
> 
> To fix this, the PFN should be initialized and marked as PG_reserved.
> This patch changes early_pfn_in_nid() return true if PFN is a hole.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

at least, this patch works fine on my ia64 box.

	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




