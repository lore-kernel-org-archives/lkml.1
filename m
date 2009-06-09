Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZFISMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZFISMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZFISMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:12:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbZFISMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:12:13 -0400
Message-ID: <4A2EA5D9.6050602@redhat.com>
Date: Tue, 09 Jun 2009 14:11:37 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Do not unconditionally treat zones that fail zone_reclaim()
 as full
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-3-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1244566904-31470-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> There is a side-effect to this patch. Currently, if zone_reclaim()
> successfully reclaimed SWAP_CLUSTER_MAX, an allocation attempt would
> go ahead. With this patch applied, zone watermarks are rechecked after
> zone_reclaim() does some work.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
