Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYJFRPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYJFRPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYJFRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:15:44 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58204 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYJFRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:15:43 -0400
Message-ID: <48EA47B7.8010304@linux.vnet.ibm.com>
Date: Mon, 06 Oct 2008 22:45:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 0/4] memcg: ready-to-go series (was memcg update v6)
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Cut out 4 patches from memcg update v5 series.
> (Then, this is a part of v6)
> 
> I think we got some agreement on these 4.
> 
> please ack if ok.
> 
> [1/4] ...  account swap under lock
> [2/4] ...  make page->mapping to be NULL before uncharge cache.
> [3/4] ...  avoid accounting not-on-LRU pages.
> [4/4] ...  optimize cpu stat
> 
> I still have 6 patches but it's under test and needs review and discussion.

Hi, Andrew,

Could you please pick this patchset, following it is a very important set of
patches that remove struct page's page_cgroup member.


-- 
	Balbir
