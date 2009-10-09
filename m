Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbZJIUet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbZJIUet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZJIUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZJIUes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:34:48 -0400
Message-ID: <4ACF9E2F.3090307@redhat.com>
Date: Fri, 09 Oct 2009 16:33:51 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] vmscan: separate sc.swap_cluster_max and sc.nr_max_reclaim
References: <20091009174756.12B5.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091009174756.12B5.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Rafael, Can you please review this patch series?
> 
> I found shrink_all_memory() is not fast at all on my numa system.
> I think this patch series fixes it.
> 
> 
> ==============================================================
> Currently, sc.scap_cluster_max has double meanings.
> 
>  1) reclaim batch size as isolate_lru_pages()'s argument
>  2) reclaim baling out thresolds
> 
> The two meanings pretty unrelated. Thus, Let's separate it.
> this patch doesn't change any behavior.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
