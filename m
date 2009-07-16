Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbZGPCKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbZGPCKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbZGPCK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:10:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49914 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbZGPCK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:10:29 -0400
Message-ID: <4A5E8C09.1030406@redhat.com>
Date: Wed, 15 Jul 2009 22:10:17 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm: shrink_inactive_lis() nr_scan accounting fix
 fix
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com> <20090716095241.9D0D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090716095241.9D0D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] mm: shrink_inactive_lis() nr_scan accounting fix fix
> 
> If sc->isolate_pages() return 0, we don't need to call shrink_page_list().
> In past days, shrink_inactive_list() handled it properly.
> 
> But commit fb8d14e1 (three years ago commit!) breaked it. current shrink_inactive_list()
> always call shrink_page_list() although isolate_pages() return 0.
> 
> This patch restore proper return value check.
> 
> 
> Requirements:
>   o "nr_taken == 0" condition should stay before calling shrink_page_list().
>   o "nr_taken == 0" condition should stay after nr_scan related statistics
>      modification.
> 
> 
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
