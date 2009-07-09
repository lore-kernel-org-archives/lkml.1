Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbZGIPFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbZGIPFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbZGIPE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:04:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZGIPE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:04:57 -0400
Message-ID: <4A5606DB.7060503@redhat.com>
Date: Thu, 09 Jul 2009 11:03:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 5/5] add shmem vmstat
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709171452.23C9.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090709171452.23C9.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
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

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
