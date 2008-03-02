Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYCBKgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYCBKgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 05:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYCBKgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 05:36:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45377 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYCBKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 05:36:03 -0500
Date: Sun, 02 Mar 2008 19:35:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 11/21] (NEW) more aggressively use lumpy reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
In-Reply-To: <20080228192928.954667833@redhat.com>
References: <20080228192908.126720629@redhat.com> <20080228192928.954667833@redhat.com>
Message-Id: <20080302193024.1E72.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I think this patch is very good improvement.
but it is not related to split lru.

Why don't you separate this patch?
IMHO treat as independent patch is better.

Thanks.

> During an AIM7 run on a 16GB system, fork started failing around
> 32000 threads, despite the system having plenty of free swap and
> 15GB of pageable memory.
> 
> If normal pageout does not result in contiguous free pages for
> kernel stacks, fall back to lumpy reclaim instead of failing fork
> or doing excessive pageout IO.
> 
> I do not know whether this change is needed due to the extreme
> stress test or because the inactive list is a smaller fraction
> of system memory on huge systems.


