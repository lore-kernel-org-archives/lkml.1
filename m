Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbZIOFHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbZIOFHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 01:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZIOFHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 01:07:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbZIOFHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 01:07:35 -0400
Message-ID: <4AAF2037.1030300@redhat.com>
Date: Tue, 15 Sep 2009 01:03:51 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO performance
References: <20090915054259.5282e5ba@infradead.org>
In-Reply-To: <20090915054259.5282e5ba@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> 		no cstates	current linux	new algorithm
> 1 disk		107 Mb/s	85 Mb/s		105 Mb/s
> 2 disks		215 Mb/s	123 Mb/s	209 Mb/s
> 12 disks	590 Mb/s	320 Mb/s	585 Mb/s

That is huge!  Should this go into -stable too?

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
