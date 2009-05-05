Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZEEMQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZEEMQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZEEMQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:16:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZEEMQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:16:44 -0400
Message-ID: <4A002DD4.4080401@redhat.com>
Date: Tue, 05 May 2009 08:15:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "npiggin@suse.de" <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmscan: ZVC updates in shrink_active_list() can be done
 once
References: <20090504234455.GA6324@localhost>
In-Reply-To: <20090504234455.GA6324@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> This effectively lifts the unit of nr_inactive_* and pgdeactivate updates
> from PAGEVEC_SIZE=14 to SWAP_CLUSTER_MAX=32.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
