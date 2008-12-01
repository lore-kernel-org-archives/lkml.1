Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbYLAOu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbYLAOu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYLAOuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:50:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbYLAOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:50:45 -0500
Message-ID: <4933F9A1.6080106@redhat.com>
Date: Mon, 01 Dec 2008 09:50:09 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 04/11] make get_scan_ratio() to memcg safe
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081201211342.1CD6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081201211342.1CD6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Currently, get_scan_ratio() always calculate the balancing value for global reclaim and
> memcg reclaim doesn't use it.
> Therefore it doesn't have scan_global_lru() condition.
> 
> However, we plan to expand get_scan_ratio() to be usable for memcg too, latter.
> Then, The dependency code of global reclaim in the get_scan_ratio() insert into
> scan_global_lru() condision explictly.
> 
> 
> this patch doesn't have any functional change.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Good in principle, though of course this particular corner
case is not going to change when reclaiming a memcg :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
