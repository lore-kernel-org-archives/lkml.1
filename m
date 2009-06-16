Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZFPJla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZFPJla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZFPJlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:41:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51875 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZFPJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:41:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/2] mm: Fix documentation of min_unmapped_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245064482-19245-3-git-send-email-mel@csn.ul.ie>
References: <1245064482-19245-1-git-send-email-mel@csn.ul.ie> <1245064482-19245-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20090616184100.99AC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Jun 2009 18:41:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -A percentage of the total pages in each zone.  Zone reclaim will only
> -occur if more than this percentage of pages are file backed and unmapped.
> -This is to insure that a minimal amount of local pages is still available for
> -file I/O even if the node is overallocated.
> +This is a percentage of the total pages in each zone. Zone reclaim will
> +only occur if more than this percentage of pages are in a state that
> +zone_reclaim_mode allows to be reclaimed.
> +
> +If zone_reclaim_mode has the value 4 OR'd, then the percentage is compared
> +against all file-backed unmapped pages including swapcache pages and tmpfs
> +files. Otherwise, only unmapped pages backed by normal files but not tmpfs
> +files and similar are considered.
>  
>  The default is 1 percent.

looks good.



