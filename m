Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbZFISQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbZFISQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZFISQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:16:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbZFISQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:16:02 -0400
Message-ID: <4A2EA6A6.30003@redhat.com>
Date: Tue, 09 Jun 2009 14:15:02 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Properly account for the number of page cache pages
 zone_reclaim() can reclaim
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1244566904-31470-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> This patch alters how zone_reclaim() works out how many pages it might be
> able to reclaim given the current reclaim_mode. If RECLAIM_SWAP is set
> in the reclaim_mode it will either consider NR_FILE_PAGES as potential
> candidates or else use NR_{IN}ACTIVE}_PAGES-NR_FILE_MAPPED to discount
> swapcache and other non-file-backed pages.  If RECLAIM_WRITE is not set,
> then NR_FILE_DIRTY number of pages are not candidates. If RECLAIM_SWAP is
> not set, then NR_FILE_MAPPED are not.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Christoph Lameter <cl@linux-foundation.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
