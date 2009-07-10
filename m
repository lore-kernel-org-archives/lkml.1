Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZGJBYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZGJBYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbZGJBYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:24:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:8319 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZGJBYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:24:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,376,1243839600"; 
   d="scan'208";a="163436824"
Date: Fri, 10 Jul 2009 09:23:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 5/5] add shmem vmstat
Message-ID: <20090710012356.GA6809@localhost>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709171452.23C9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709171452.23C9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 04:18:01PM +0800, KOSAKI Motohiro wrote:
> ChangeLog
>   Since v1
>    - Fixed misaccounting bug on page migration
> 
> ========================
> Subject: [PATCH] add shmem vmstat
> 
> Recently, We faced several OOM problem by plenty GEM cache. and generally,
> plenty Shmem/Tmpfs potentially makes memory shortage problem.
> 
> We often use following calculation to know shmem pages,
>   shmem = NR_ACTIVE_ANON + NR_INACTIVE_ANON - NR_ANON_PAGES
> but it is wrong expression. it doesn't consider isolated page and
> mlocked page.
> 
> Then, This patch make explicit Shmem/Tmpfs vm-stat accounting.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks for the nice work!
