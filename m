Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYF3IRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYF3IRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYF3IRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:17:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50791 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYF3IRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:17:13 -0400
Date: Mon, 30 Jun 2008 17:17:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC 5/5] Memory controller soft limit reclaim on contention
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48689527.7070403@linux.vnet.ibm.com>
References: <20080630165125.37E6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48689527.7070403@linux.vnet.ibm.com>
Message-Id: <20080630171608.37E9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > yes, memcg used only one page.
> > but mem_cgroup_reclaim_on_contention() reclaim for generic alloc_pages(), instead for memcg.
> > we can't assume memcg usage.
> > isn't it?
> 
> Yes, but the reclaim is from memcg pages (memcg groups that are over their soft
> limit). I am not sure if I understand your point? If your claim is that we don't
> free up pages of at-least order (as desired by __alloc_pages_internal()), that
> is correct. We can ensure that we do a pass over memcg and generic zone LRU.

exactly.
Thank you.


