Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYIVPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYIVPsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYIVPsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:48:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:59828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYIVPsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:48:02 -0400
Subject: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer
	from struct page)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 17:47:49 +0200
Message-Id: <1222098469.16700.38.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 20:12 +0900, KAMEZAWA Hiroyuki wrote:

>   - all page_cgroup struct is maintained by hash. 
>     I think we have 2 ways to handle sparse index in general
>     ...radix-tree and hash. This uses hash because radix-tree's layout is
>     affected by memory map's layout.

Could you provide further detail? That is, is this solely because our
radix tree implementation is sucky for large indexes?

If so, I did most of the work of fixing that, just need to spend a
little more time to stabalize the code.

