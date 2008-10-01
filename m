Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYJADuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYJADuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYJADui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:50:38 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:48870 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbYJADuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:50:37 -0400
Message-ID: <48E2F389.40101@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2008 09:20:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] memcg: set page->mapping NULL before uncharge
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com> <20080929192240.ddd59d7f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080929192240.ddd59d7f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This patch tries to make page->mapping to be NULL before
> mem_cgroup_uncharge_cache_page() is called.
> 
> "page->mapping == NULL" is a good check for "whether the page is still
> radix-tree or not".
> This patch also adds BUG_ON() to mem_cgroup_uncharge_cache_page();
> 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
